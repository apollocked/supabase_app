import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientProvider extends ChangeNotifier {
  final client = Supabase.instance.client;

  ClientProvider() {
    client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
  bool get isSignedIn => client.auth.currentUser != null;

  Future<void> signUp(String email, String password, String username) async {
    await client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }
}
