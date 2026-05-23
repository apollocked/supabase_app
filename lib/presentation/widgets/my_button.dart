import 'package:flutter/material.dart';

ElevatedButton myButton(
  BuildContext context,
  VoidCallback onPressed,
  String text,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size(350, 50)),
      backgroundColor: WidgetStatePropertyAll(Colors.purpleAccent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    child: Text(text, style: TextStyle(color: Colors.white)),
  );
}
