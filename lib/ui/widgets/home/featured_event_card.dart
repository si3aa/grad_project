import 'package:Herfa/ui/provider/cubit/event_cubit.dart';
import 'package:flutter/material.dart';

class FeaturedEventCard extends StatelessWidget {
  final FeaturedEvent event;

  const FeaturedEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(event.imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Icon(
              Icons.star,
              color: event.isInterested ? Colors.yellow : Colors.grey,
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Location: ${event.location}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}