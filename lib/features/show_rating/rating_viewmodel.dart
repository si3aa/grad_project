import 'package:Herfa/features/show_rating/rating_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingState {
  final bool isLoading;
  final double? rating;
  final String? error;

  RatingState({this.isLoading = false, this.rating, this.error});

  RatingState copyWith({bool? isLoading, double? rating, String? error}) {
    return RatingState(
      isLoading: isLoading ?? this.isLoading,
      rating: rating ?? this.rating,
      error: error ?? this.error,
    );
  }
}

class RatingCubit extends Cubit<RatingState> {
  final RatingRepository repository;
  RatingCubit(this.repository) : super(RatingState(isLoading: false));

  Future<void> fetchRating(int productId) async {
    emit(RatingState(isLoading: true));
    try {
      final response = await repository.fetchAverageRating(productId);
      emit(RatingState(isLoading: false, rating: response.data));
    } catch (e) {
      emit(RatingState(isLoading: false, error: e.toString()));
    }
  }
}
