import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientProvider extends ChangeNotifier {
  final client = Supabase.instance.client;
  bool isLoading = false;

  ClientProvider() {
    client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  bool get isSignedIn => client.auth.currentUser != null;

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners(); // Notify UI that loading started
    try {
      await client.auth.signInWithPassword(email: email, password: password);
    } finally {
      // 'finally' runs whether the code succeeded OR failed
      isLoading = false;
      notifyListeners(); // Notify UI that loading stopped
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    isLoading = true;
    notifyListeners();
    try {
      await client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }
}
