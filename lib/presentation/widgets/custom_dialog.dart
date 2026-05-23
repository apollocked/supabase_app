import 'package:flutter/material.dart';

Future<dynamic> customDialog(
  BuildContext context,

  String title,
  TextEditingController noteControler,
  VoidCallback onSave,
) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter a note',
        ),
        controller: noteControler,
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            noteControler.clear();
            Navigator.pop(context);
          },
        ),
        TextButton(onPressed: onSave, child: Text('Save')),
      ],
    ),
  );
}
