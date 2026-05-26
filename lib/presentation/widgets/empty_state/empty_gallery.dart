import 'package:flutter/material.dart';

class EmptyGalleryWidget extends StatelessWidget {
  const EmptyGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Images',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Upload New Image', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Icon(Icons.image, size: 100, color: Colors.pinkAccent),
        ],
      ),
    );
  }
}
