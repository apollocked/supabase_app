import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(
  String message,
  BuildContext context,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      elevation: 4,
      dismissDirection: DismissDirection.horizontal,
      clipBehavior: Clip.antiAlias,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: Duration(seconds: 2),
    ),
  );
}
