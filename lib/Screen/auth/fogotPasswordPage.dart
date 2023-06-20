import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/myButton.dart';
import 'package:social_app/components/myTextFromField.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future PasswordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      _showErroDialog('Please check your email to reset your password.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErroDialog('No user found for that email.');
      }
    }
  }

  void _showErroDialog(error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
        title: const Text('notice'),
        content: Text(error.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Enter your email address to reset your password'),
                const SizedBox(height: 20),
                MyTextFromField(
                  controller: _emailController,
                  title: 'Email Address',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: PasswordReset,
                ),
              ],
            ),
          ),
        ),
      ),
      // back button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
