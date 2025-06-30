import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodel/rating_viewmodel.dart';
import '../data/repo/rating_repository.dart';

class ShowRatingWidget extends StatelessWidget {
  final int productId;
  const ShowRatingWidget({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RatingCubit(RatingRepository())..fetchRating(productId),
      child: BlocBuilder<RatingCubit, RatingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SizedBox(
                height: 24,
                width: 60,
                child:
                    Center(child: CircularProgressIndicator(strokeWidth: 2)));
          } else if (state.error != null) {
            return const SizedBox(
                height: 24,
                width: 60,
                child: Icon(Icons.error, color: Colors.red));
          } else if (state.rating != null) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.rating!.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20, color: Colors.blue),
                  tooltip: 'Refresh Rating',
                  onPressed: () {
                    // Re-fetch the rating and print response
                    context.read<RatingCubit>().fetchRating(productId);
                  },
                ),
              ],
            );
          } else {
            return const SizedBox(height: 24, width: 60);
          }
        },
      ),
    );
  }
}
