import 'package:flutter/material.dart';

Future<dynamic> customConfirmationDialog(
  BuildContext context,
  String title,
  String content,
  String confermationText,
  VoidCallback onSave, {
  Color color = Colors.red,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          onPressed: onSave,
          child: Text(confermationText, style: TextStyle(color: color)),
        ),
      ],
    ),
  );
}
