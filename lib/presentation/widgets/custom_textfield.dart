import 'package:flutter/material.dart';

TextField customTextField(
  TextEditingController controler,
  IconData icon,
  String hint, {
  bool isObsecure = false,
  void Function(String)? onChanged,
}) {
  return TextField(
    controller: controler,
    obscureText: isObsecure,
    onChanged: onChanged ?? (_) {},
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      hintText: hint,
      prefixIcon: Icon(icon),
    ),
  );
}
