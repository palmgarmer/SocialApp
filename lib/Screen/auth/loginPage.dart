import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Screen/auth/fogotPasswordPage.dart';
import 'package:social_app/components/myButton.dart';
import 'package:social_app/components/myTextFromField.dart';
import 'package:social_app/components/squreTile.dart';
import 'package:social_app/services/authService.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // text edting controller
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  // show error massage
  void _showErrorMassage(String massage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(massage),
      ),
    );
  }

  // sign in user
  void _signInUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try to sign in user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // hide loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // hide loading circle
      Navigator.pop(context);
      // show error massage
      _showErrorMassage(e.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Login Logo
                  const Text("Login",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(
                    height: 5,
                  ),

                  // welcome text
                  const Text(
                    "Welcome! Let's take to your account.",
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //Username
                  MyTextFromField(
                    controller: _emailController,
                    title: 'Email Adress',
                    obscureText: false,
                  ),

                  // Password
                  MyTextFromField(
                    controller: _passwordController,
                    title: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Forgot Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ForgotPasswordPage();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Continue Button
                  MyButton(
                    onTap: _signInUser,
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //Or continue with
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("OR"),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  SqureTile(
                    imagePath: 'lib/images/google.png',
                    title: 'Google',
                    onTap: () => AuthService().signInWithGoogle(),
                  ),

                  const SizedBox(
                    height: 35,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account ?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
