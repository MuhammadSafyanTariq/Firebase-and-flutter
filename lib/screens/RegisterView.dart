import 'package:codecamp/constants/Routes.dart';
import 'package:codecamp/services/auth/auth_exceptions.dart';
import 'package:codecamp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../utilities/Show_Error_Dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      appBar: AppBar(title: Text("Register")),
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
                      .createUser(email: email, password: password);
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                } on WeekPasswordAuthException {
                  await showMsgDialog(context, "Week Password");
                } on EmailAlreadyInUsedAuthException {
                  await showMsgDialog(context, "Already used email");
                } on InvalidEmailAuthException {
                  await showMsgDialog(context, "Invalid email");
                } on GenericAuthException {
                  await showMsgDialog(context, "An Unknown Error occured");
                }
              },
              child: const Text("Register")),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Go to login page")),
        ],
      ),
    );
  }
}
