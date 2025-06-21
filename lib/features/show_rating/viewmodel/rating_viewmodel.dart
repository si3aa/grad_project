import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/rating_repository.dart';

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
      print('Rating fetch error: ' + e.toString());
      emit(RatingState(isLoading: false, error: e.toString()));
    }
  }
}
