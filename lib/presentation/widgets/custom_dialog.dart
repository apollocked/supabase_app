import 'package:flutter/material.dart';
import 'package:my_supabase_app/presentation/widgets/custom_textfield.dart';

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
      content: customTextField(noteControler, Icons.note, 'Enter a note'),
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
