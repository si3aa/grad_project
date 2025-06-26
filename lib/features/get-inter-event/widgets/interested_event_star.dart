import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/get_inter_event_cubit.dart';

class InterestedEventStar extends StatelessWidget {
  final String eventId;
  final double size;

  const InterestedEventStar({
    Key? key,
    required this.eventId,
    this.size = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetInterEventCubit, GetInterEventState>(
      builder: (context, state) {
        final cubit = context.read<GetInterEventCubit>();
        final isInterested = cubit.isInterested(eventId);
        return IconButton(
          icon: Icon(
            isInterested ? Icons.star : Icons.star_border,
            color: isInterested ? Colors.amber : Colors.grey,
          ),
          iconSize: size,
          onPressed: () {
            if (isInterested) {
              cubit.removeInterest(eventId);
            } else {
              cubit.addInterest(eventId);
            }
          },
        );
      },
    );
  }
}
