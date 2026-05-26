import 'package:flutter/material.dart';

class EmptyNotes extends StatelessWidget {
  const EmptyNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Notes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Add New Note', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Icon(Icons.note_alt_rounded, size: 100, color: Colors.pinkAccent),
        ],
      ),
    );
  }
}
