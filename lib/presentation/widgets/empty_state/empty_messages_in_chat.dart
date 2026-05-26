import 'package:flutter/material.dart';

class EmptyMessagesInChat extends StatelessWidget {
  const EmptyMessagesInChat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Messages',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Start a conversation', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Icon(Icons.aod_rounded, size: 100, color: Colors.pinkAccent),
        ],
      ),
    );
  }
}
