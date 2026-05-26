// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:my_supabase_app/core/logic/chat_provider.dart';
import 'package:my_supabase_app/presentation/pages/messages/create_group.dart';
import 'package:my_supabase_app/presentation/widgets/empty_state/empty_chat_list.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'chat_page.dart';
import 'new_dm_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late ChatProvider chatProvider;
  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.loadChats();
      chatProvider.subscribeToChats();
    });
  }

  @override
  void dispose() {
    chatProvider.unsubscribeFromChats();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () async {
              final groupId = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (_) => const NewDMPage()),
              );
              if (groupId != null) {
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatPage(groupId: groupId)),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () async {
              final groupId = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (_) => const CreateGroupPage()),
              );
              if (groupId != null) {
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatPage(groupId: groupId)),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          if (chatProvider.isLoading && chatProvider.chats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (chatProvider.chats.isEmpty) {
            return const EmptyChatList();
          }
          return ListView.builder(
            itemCount: chatProvider.chats.length,
            itemBuilder: (context, index) {
              final chat = chatProvider.chats[index];
              final isGroup = chat['is_group'] as bool;
              final lastMessage =
                  chat['last_message'] as String? ?? 'No messages yet';
              final lastTime = chat['last_message_time'] as String?;
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(isGroup ? Icons.group : Icons.person),
                ),
                title: Text(chat['name']),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: lastTime != null
                    ? Text(
                        timeago.format(DateTime.parse(lastTime)),
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(groupId: chat['group_id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
