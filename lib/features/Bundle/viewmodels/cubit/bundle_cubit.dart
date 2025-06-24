import 'package:flutter_bloc/flutter_bloc.dart';

class BundleState {
  final List<dynamic> bundles;
  final bool isLoading;
  final String? error;

  const BundleState({
    this.bundles = const [],
    this.isLoading = false,
    this.error,
  });

  BundleState copyWith({
    List<dynamic>? bundles,
    bool? isLoading,
    String? error,
  }) {
    return BundleState(
      bundles: bundles ?? this.bundles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BundleCubit extends Cubit<BundleState> {
  BundleCubit() : super(const BundleState());

  Future<void> fetchAllBundles() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(bundles: [], isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
