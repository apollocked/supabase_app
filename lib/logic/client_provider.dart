import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientProvider extends ChangeNotifier {
  final client = Supabase.instance.client;
  final auth = Supabase.instance.client.auth.currentUser;
  bool isSignedIn() => auth != null;

  Future<void> signUp(String email, String password) async {
    await client.auth.signUp(email: email, password: password);
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await client.auth.signOut();
    notifyListeners();
  }
}
