import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/myButton.dart';
import 'package:social_app/components/myTextFromField.dart';
import 'package:social_app/components/squreTile.dart';
import 'package:social_app/services/authService.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // text edting controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
  void _signUpUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (_passwordController.text != _confirmPasswordController.text) {
      // hide loading circle
      Navigator.pop(context);
      // show error massage
      _showErrorMassage('Password does not match');
      return;
    } else {
      // try to create user
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
                  const Text("Sign Up",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(
                    height: 5,
                  ),

                  // welcome text
                  const Text(
                    "Welcome! Let's create your account.",
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

                  // confirm password
                  MyTextFromField(
                    controller: _confirmPasswordController,
                    title: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Continue Button
                  MyButton(
                    onTap: _signUpUser,
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
                        "Already have an account ?",
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
                          "Sign In",
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
