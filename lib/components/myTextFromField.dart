import 'package:flutter/material.dart';

class MyTextFromField extends StatelessWidget {
  final controller;
  final String title;
  final bool obscureText;

  const MyTextFromField({
    super.key,
    required this.controller,
    required this.title,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(title),
        ),
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $title';
          }
          if (title == 'Email Adress') {
            if (!value.contains('@') || !value.contains('.')) {
              return 'Please enter valid email';
            }
          }

          return null;
        },
      ),
    );
  }
}
