import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  final Function()? onTap;
  final bool isShare;
  final int shareCount;
  const ShareButton({
    super.key,
    required this.onTap,
    required this.isShare,
    required this.shareCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Transform.flip(
            flipX: true,
            child: Icon(
              Icons.file_upload_outlined,
              color: isShare == true ? Colors.green : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            shareCount.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
