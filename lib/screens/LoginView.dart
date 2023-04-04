import 'package:codecamp/constants/Routes.dart';
import 'package:codecamp/services/auth/auth_exceptions.dart';
import 'package:codecamp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../utilities/Show_Error_Dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Enter your email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: "Enter your password"),
          ),
          TextButton(
              onPressed: () async {
                try {
                  final email = _email.text;
                  final password = _password.text;
                  await AuthService.firebase()
                      .login(email: email, password: password);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } on UserNotFoundAuthException {
                  await showMsgDialog(context, "User not found");
                } on WrongPasswordAuthException {
                  await showMsgDialog(context, "Wrong Password");
                } on GenericAuthException catch (e) {
                  await showMsgDialog(context, "Error: $e");
                } catch (e) {
                  await showMsgDialog(context, e.toString());
                }
              },
              child: Text("Login")),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text("Not Registered yet? Sign up")),
        ],
      ),
    );
  }
}
