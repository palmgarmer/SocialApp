import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfilePic extends StatelessWidget {
  MyProfilePic({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(2),
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          // if user has profile picture, use it
          user!.photoURL ?? 'https://shorturl.at/pvBMR',
        ),
      ),
    );
  }
}
