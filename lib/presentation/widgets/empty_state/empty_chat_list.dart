import 'package:flutter/material.dart';

class EmptyChatList extends StatelessWidget {
  const EmptyChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Chats',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Start a conversation with a friend',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Icon(
            Icons.spatial_tracking_outlined,
            size: 100,
            color: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }
}
