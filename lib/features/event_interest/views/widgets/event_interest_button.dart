import 'package:Herfa/features/event_interest/viewmodels/cubit/event_interest_cubit.dart';
import 'package:Herfa/features/event_interest/viewmodels/cubit/event_interest_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/constants.dart';

class EventInterestButton extends StatelessWidget {
  final String eventId;
  final double size;

  const EventInterestButton({
    Key? key,
    required this.eventId,
    this.size = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventInterestCubit, EventInterestState>(
      listener: (context, state) {
        // SnackBar removed as requested
      },
      builder: (context, state) {
        final isInterested =
            context.read<EventInterestCubit>().getInterestStatus(eventId);

        return GestureDetector(
          onLongPress: () => _handleLongPress(context),
          child: IconButton(
            icon: Icon(
              isInterested == true ? Icons.star : Icons.star_border,
              color: isInterested == true ? kPrimaryColor : kPrimaryColor,
            ),
            iconSize: size,
            onPressed: () => _handleTap(context),
            padding: const EdgeInsets.all(4),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context) {
    final cubit = context.read<EventInterestCubit>();
    final currentStatus = cubit.getInterestStatus(eventId);

    if (currentStatus == null) {
      // First time - check status then toggle
      cubit.checkInterestStatus(eventId).then((_) {
        cubit.toggleInterest(eventId);
      });
    } else {
      // We know the status - just toggle
      cubit.toggleInterest(eventId);
    }
  }

  void _handleLongPress(BuildContext context) {
    final cubit = context.read<EventInterestCubit>();
    final isInterested = cubit.getInterestStatus(eventId);

    if (isInterested == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove Interest'),
            content: const Text(
                'Are you sure you want to remove your interest in this event?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.toggleInterest(eventId);
                },
                child: const Text('Remove'),
              ),
            ],
          );
        },
      );
    }
  }
}
