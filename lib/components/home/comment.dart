import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // comment
        Text(text),

        //time
        Row(
          children: [
            Text(
              user,
              style: TextStyle(
                  fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
            ),
            const Text(" · "),
            Text(
              time,
              style: TextStyle(
                  fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
      ],
    );
  }
}
