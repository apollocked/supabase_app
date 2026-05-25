import 'package:flutter/material.dart';
import 'package:my_supabase_app/helpers/format_timer.dart';

class Chat extends StatelessWidget {
  const Chat({
    super.key,
    required ScrollController scrollController,
    required this.messages,
    required this.currentUserId,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<Map<String, dynamic>> messages;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isMe = msg['sender_id'] == currentUserId;
        final senderName = msg['profiles']?['username'] ?? 'Unknown';
        final content = msg['content'] as String;
        final time = msg['created_at'] as String;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    senderName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  formatTime(time),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
