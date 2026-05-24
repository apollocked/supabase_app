import 'package:flutter/material.dart';
import 'package:my_supabase_app/core/failures.dart';
import 'package:my_supabase_app/logic/client_provider.dart';
import 'package:my_supabase_app/presentation/pages/auth/signin_page.dart';
import 'package:my_supabase_app/presentation/widgets/custom_textfield.dart';
import 'package:my_supabase_app/presentation/widgets/my_button.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final supabase = Supabase.instance.client;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  Future<void> signUp() async {
    final auth = context.read<ClientProvider>();
    if (auth.isLoading) return;
    try {
      await auth.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        usernameController.text.trim(),
      );
      if (!mounted) {
        return;
      }
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      failures(context, e);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
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
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        customTextField(
                          usernameController,
                          Icons.person,
                          'Username',
                        ),
                        customTextField(emailController, Icons.email, 'Email'),
                        customTextField(
                          passwordController,
                          Icons.lock,
                          'Password',
                          isObsecure: true,
                        ),
                      ],
                    ),
                  ),
                ),
                myButton(context, () {
                  signUp();
                }, 'Sign Up'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign In',
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
