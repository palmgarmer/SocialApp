import 'package:flutter/material.dart';
import 'package:social_app/Screen/auth/loginPage.dart';
import 'package:social_app/Screen/auth/registerPage.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register page
  void _togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage == true) {
      return LoginPage(
        onTap: _togglePage,
      );
    } else {
      return RegisterPage(
        onTap: _togglePage,
      );
    }
  }
}
