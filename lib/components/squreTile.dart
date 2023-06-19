import 'package:flutter/material.dart';

class SqureTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final Function()? onTap;
  const SqureTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text('Continue with $title',
                style: const TextStyle(
                  color: Colors.black,
                ))
          ],
        ),
      ),
    );
  }
}
