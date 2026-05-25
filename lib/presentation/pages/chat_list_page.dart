// lib/pages/chat_list_page.dart
import 'package:flutter/material.dart';
import 'package:my_supabase_app/logic/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatProvider>();
      chatProvider.loadChats();
      chatProvider.subscribeToChats();
    });
  }

  @override
  void dispose() {
    context.read<ChatProvider>().unsubscribeFromChats();
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
            onPressed: () async {},
          ),
          IconButton(icon: const Icon(Icons.group_add), onPressed: () async {}),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          if (chatProvider.isLoading && chatProvider.chats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.chats.isEmpty) {
            return const Center(
              child: Text('No chats yet.\nStart a new conversation!'),
            );
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
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
