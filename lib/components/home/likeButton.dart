import 'package:flutter/material.dart';

class MyLikeButton extends StatelessWidget {
  final bool isLike;
  void Function() onTap;
  final int likeCount;
  MyLikeButton({
    super.key,
    required this.isLike,
    required this.onTap,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(
            Icons.favorite,
            color: isLike == true ? Colors.red : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          likeCount.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
