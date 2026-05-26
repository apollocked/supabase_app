import 'package:flutter/material.dart';
import 'package:my_supabase_app/core/logic/chat_provider.dart';
import 'package:my_supabase_app/presentation/widgets/chats_widget.dart';
import 'package:my_supabase_app/presentation/widgets/custom_textfield.dart';
import 'package:my_supabase_app/presentation/widgets/empty_state/empty_messages_in_chat.dart';
import 'package:my_supabase_app/presentation/widgets/show_group_info.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  const ChatPage({super.key, required this.groupId});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late ChatProvider chatProvider;
  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.loadMessages(widget.groupId);
      chatProvider.subscribeToMessages(widget.groupId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    chatProvider.unsubscribeFromMessages();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();
    await context.read<ChatProvider>().sendMessage(widget.groupId, content);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<ChatProvider>().currentUserId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showGroupInfo(context, widget.groupId);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                final messages = chatProvider.messages;
                if (messages.isEmpty) {
                  return const EmptyMessagesInChat();
                }
                _scrollToBottom();
                return Chat(
                  scrollController: _scrollController,
                  messages: messages,
                  currentUserId: currentUserId,
                );
              },
            ),
          ),
          // Message Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withAlpha(30),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: customTextField(
                      _messageController,
                      Icons.message,
                      'Type a message...',
                      isObsecure: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
