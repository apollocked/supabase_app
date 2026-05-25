// lib/providers/chat_provider.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  bool isLoading = false;
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> searchUsers = [];
  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _chatsChannel;

  String get currentUserId => _client.auth.currentUser!.id;

  // LOAD ALL CHATS FOR USER
  Future<void> loadChats() async {
    isLoading = true;
    notifyListeners();

    try {
      // Get all groups the current user belongs to
      final response = await _client
          .from('group_members')
          .select('''
            group_id,
            groups (
              id,
              name,
              is_group,
              avatar_url,
              created_at,
              group_members (
                user_id,
                profiles (
                  id,
                  username,
                  avatar_url
                )
              ),
              messages (
                id,
                content,
                created_at,
                sender_id,
                profiles (
                  username
                )
              )
            )
          ''')
          .eq('user_id', currentUserId)
          .order('joined_at', ascending: false);

      chats = response.map<Map<String, dynamic>>((item) {
        final group = item['groups'] as Map<String, dynamic>;

        // Get chat display name (for DM: show other user's name)
        String displayName = group['name'] as String;
        if (!(group['is_group'] as bool)) {
          final members = group['group_members'] as List;
          for (var member in members) {
            if (member['user_id'] != currentUserId) {
              displayName = member['profiles']['username'] ?? 'Unknown';
            }
          }
        }

        // Get last message
        String lastMessage = '';
        String? lastMessageTime;
        final msgs = group['messages'] as List;
        if (msgs.isNotEmpty) {
          final lastMsg = msgs.last;
          lastMessage = lastMsg['content'] as String;
          lastMessageTime = lastMsg['created_at'] as String;
        }

        return {
          'group_id': group['id'],
          'name': displayName,
          'is_group': group['is_group'],
          'avatar_url': group['avatar_url'],
          'last_message': lastMessage,
          'last_message_time': lastMessageTime,
          'members': group['group_members'],
        };
      }).toList();

      // Sort by last message time
      chats.sort((a, b) {
        final aTime = a['last_message_time'] as String? ?? '';
        final bTime = b['last_message_time'] as String? ?? '';
        return bTime.compareTo(aTime);
      });
    } catch (e) {
      debugPrint('Error loading chats: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // SEARCH USERS
  Future<void> searchUsersByUsername(String query) async {
    if (query.isEmpty) {
      searchUsers = [];
      notifyListeners();
      return;
    }

    try {
      final response = await _client
          .from('profiles')
          .select()
          .neq('id', currentUserId)
          .ilike('username', '%$query%');

      searchUsers = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error searching users: $e');
    }

    notifyListeners();
  }

  // START OR GET DM CONVERSATION
  Future<String?> getOrCreateDM(String otherUserId) async {
    try {
      // Find existing DM group with both users
      final myGroups = await _client
          .from('group_members')
          .select('group_id')
          .eq('user_id', currentUserId);

      final myGroupIds = myGroups
          .map<String>((g) => g['group_id'] as String)
          .toList();

      if (myGroupIds.isNotEmpty) {
        final otherMember = await _client
            .from('group_members')
            .select('group_id')
            .eq('user_id', otherUserId)
            .in_('group_id', myGroupIds); // Fixed: changed inFilter to in_

        for (var m in otherMember) {
          final groupId = m['group_id'] as String;
          // Check if it's a DM (not a group)
          final groupData = await _client
              .from('groups')
              .select('is_group')
              .eq('id', groupId)
              .single();

          if (groupData['is_group'] == false) {
            return groupId;
          }
        }
      }

      // Create new DM
      final groupResponse = await _client
          .from('groups')
          .insert({
            'name': 'DM',
            'is_group': false,
            'created_by': currentUserId,
          })
          .select()
          .single();

      final groupId = groupResponse['id'] as String;

      // Add both users as members
      await _client.from('group_members').insert([
        {'group_id': groupId, 'user_id': currentUserId},
        {'group_id': groupId, 'user_id': otherUserId},
      ]);

      await loadChats();
      return groupId;
    } catch (e) {
      debugPrint('Error creating DM: $e');
      return null;
    }
  }

  // CREATE GROUP
  Future<String?> createGroup(String groupName, List<String> memberIds) async {
    try {
      // Create the group
      final groupResponse = await _client
          .from('groups')
          .insert({
            'name': groupName,
            'is_group': true,
            'created_by': currentUserId,
          })
          .select()
          .single();

      final groupId = groupResponse['id'] as String;

      // Add current user + selected members
      final members = [
        {'group_id': groupId, 'user_id': currentUserId},
        ...memberIds.map((id) => {'group_id': groupId, 'user_id': id}),
      ];

      await _client.from('group_members').insert(members);

      await loadChats();
      return groupId;
    } catch (e) {
      debugPrint('Error creating group: $e');
      return null;
    }
  }

  // LOAD MESSAGES
  Future<void> loadMessages(String groupId) async {
    try {
      final response = await _client
          .from('messages')
          .select('*, profiles(username, avatar_url)')
          .eq('group_id', groupId)
          .order('created_at', ascending: true);

      messages = List<Map<String, dynamic>>.from(response);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  // SEND MESSAGE
  Future<void> sendMessage(String groupId, String content) async {
    try {
      await _client.from('messages').insert({
        'group_id': groupId,
        'sender_id': currentUserId,
        'content': content.trim(),
      });
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  // SUBSCRIBE TO REALTIME MESSAGES
  void subscribeToMessages(String groupId) {
    _messagesChannel = _client.channel('messages:$groupId');

    // Fixed: Updated to the correct .on() Postgres rules API
    _messagesChannel!.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'messages',
        filter: 'group_id=eq.$groupId',
      ),
      (payload, [ref]) async {
        // Reload messages when a new message arrives
        await loadMessages(groupId);
      },
    );

    _messagesChannel!.subscribe();
  }

  // SUBSCRIBE TO CHAT LIST UPDATES
  void subscribeToChats() {
    _chatsChannel = _client.channel('chats:$currentUserId');

    // Fixed: Updated to the correct .on() API
    _chatsChannel!.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public', table: 'messages'),
      (payload, [ref]) async {
        await loadChats();
      },
    );

    _chatsChannel!.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public', table: 'group_members'),
      (payload, [ref]) async {
        await loadChats();
      },
    );

    _chatsChannel!.subscribe();
  }

  // UNSUBSCRIBE
  void unsubscribeFromMessages() {
    if (_messagesChannel != null) {
      _client.removeChannel(_messagesChannel!);
      _messagesChannel = null;
    }
  }

  void unsubscribeFromChats() {
    if (_chatsChannel != null) {
      _client.removeChannel(_chatsChannel!);
      _chatsChannel = null;
    }
  }

  // GET GROUP MEMBERS
  Future<List<Map<String, dynamic>>> getGroupMembers(String groupId) async {
    try {
      final response = await _client
          .from('group_members')
          .select('*, profiles(username, avatar_url)')
          .eq('group_id', groupId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getting members: $e');
      return [];
    }
  }

  @override
  void dispose() {
    unsubscribeFromMessages();
    unsubscribeFromChats();
    super.dispose();
  }
}
