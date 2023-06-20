import 'package:flutter/material.dart';

class MyProfileIconButton extends StatelessWidget {
  final Function()? onTap;
  MyProfileIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.5),
        ),
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
