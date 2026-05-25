import 'package:flutter/material.dart';
import 'package:my_supabase_app/logic/client_provider.dart';
import 'package:my_supabase_app/presentation/pages/auth/login_or_register.dart';
import 'package:my_supabase_app/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ClientProvider())],
      child: const MySupabaseApp(),
    ),
  );
}

class MySupabaseApp extends StatelessWidget {
  const MySupabaseApp({super.key});
  @override
  Widget build(BuildContext context) {
    bool isloggedIn = context.watch<ClientProvider>().isSignedIn;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isloggedIn ? HomePage() : const LoginOrRegisterPage(),
    );
  }
}
