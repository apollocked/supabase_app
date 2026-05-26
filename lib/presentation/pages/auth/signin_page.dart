// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_supabase_app/core/failures.dart';
import 'package:my_supabase_app/core/logic/client_provider.dart';
import 'package:my_supabase_app/presentation/widgets/custom_textfield.dart';
import 'package:my_supabase_app/presentation/widgets/my_button.dart';
import 'package:my_supabase_app/presentation/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  final void Function()? onTap;
  const SignInPage({super.key, required this.onTap});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  Future<void> signIn() async {
    final auth = context.read<ClientProvider>();
    if (auth.isLoading) return;
    try {
      if (emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        mySnackBar(
          "Email and password is required ",
          context,
          color: Colors.red,
        );
        return;
      }
      await auth.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } on AuthException catch (e) {
      failures(context, e);
    } catch (e) {
      mySnackBar("Something went wrong", context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Container(
                  height: 225,
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      customTextField(emailController, Icons.email, "Email"),
                      customTextField(
                        passwordController,
                        Icons.lock,
                        "Password",
                        isObsecure: true,
                      ),
                    ],
                  ),
                ),
                myButton(context, signIn, 'Sign In'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: widget.onTap,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
