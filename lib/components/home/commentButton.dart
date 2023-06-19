import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  void Function() onTap;
  final bool isComment;
  final int commentCount;
  CommentButton({
    super.key,
    required this.onTap,
    required this.isComment,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Transform.flip(
            flipX: true,
            child: isComment == true
                ? const Icon(
                    Icons.chat_bubble,
                    color: Colors.blue,
                    size: 20,
                  )
                : const Icon(
                    Icons.chat_bubble,
                    color: Colors.grey,
                    size: 20,
                  ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          commentCount.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
