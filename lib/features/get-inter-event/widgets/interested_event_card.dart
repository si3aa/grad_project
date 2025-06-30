import 'package:flutter/material.dart';

class InterestedEventCard extends StatelessWidget {
  final dynamic event;
  final VoidCallback? onRemoveInterest;

  const InterestedEventCard({
    Key? key,
    required this.event,
    this.onRemoveInterest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 120,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  event['media'] ?? '',
                  height: 70,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 70,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  event['name'] ?? 'No Name',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 8,
          child: GestureDetector(
            onTap: onRemoveInterest,
            child: const Icon(
              Icons.star,
              color: Colors.amber,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
