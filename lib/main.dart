import 'package:codecamp/screens/LoginView.dart';
import 'package:codecamp/screens/RegisterView.dart';
import 'package:codecamp/screens/notes_view.dart';
import 'package:codecamp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'constants/Routes.dart';
import 'package:codecamp/screens/Email_Verify_View.dart';
import 'dart:developer';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified || true) {
                  return NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginPage();
              }
              return const Text("Donee");
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
