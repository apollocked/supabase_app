import 'package:flutter/material.dart';
import 'package:my_supabase_app/presentation/widgets/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

dynamic failures(BuildContext context, AuthException e) {
  String errorMessage;

  final errorMsgLower = e.message.toLowerCase();

  if (errorMsgLower.contains("invalid login credentials")) {
    errorMessage = "The email or password you entered is incorrect.";
  } else if (errorMsgLower.contains("email not confirmed")) {
    errorMessage = "Please verify your email address to sign in.";
  } else if (errorMsgLower.contains("already registered") ||
      errorMsgLower.contains("user already exists")) {
    errorMessage = "A user with this email already exists.";
  } else if (errorMsgLower.contains("weak password")) {
    errorMessage = "Password should be at least 6 characters.";
  } else {
    errorMessage = e.message;
  }
  if (errorMessage.isEmpty) {
    errorMessage = "An error occurred. Please try again.";
  }
  mySnackBar(errorMessage, context);
}
