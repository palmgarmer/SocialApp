import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function()? onTap;
  const DeleteButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: const Row(
          children: [
            Text(
              "Delete Post",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            SizedBox(width: 15),
            Icon(
              Icons.delete_rounded,
              color: Colors.red,
              size: 20,
            ),
          ],
        ));
  }
}
