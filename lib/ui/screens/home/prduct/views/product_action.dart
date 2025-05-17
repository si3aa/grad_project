import 'package:flutter/material.dart';

/// Widget to display product interactions (likes, comments).
class ProductInteractions extends StatelessWidget {
  final int likes;
  final int comments;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const ProductInteractions({
    super.key,
    required this.likes,
    required this.comments,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onLike,
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
            size: 20,
            semanticLabel: 'Like',
          ),
        ),
        const SizedBox(width: 5),
        Text('$likes'),
        const SizedBox(width: 20),
        IconButton(
          onPressed: onComment,
          icon: Icon(
            Icons.comment,
            color: Colors.grey.shade600,
            size: 20,
            semanticLabel: 'Comment',
          ),
        ),
        const SizedBox(width: 5),
        Text('$comments'),
      ],
    );
  }
}
