import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/show_bundels/data/bundle_model.dart';
import 'package:Herfa/features/show_bundels/data/bundle_repository.dart';

part 'bundle_state.dart';

class BundleCubit extends Cubit<BundleState> {
  final BundleRepository repository;
  BundleCubit(this.repository) : super(BundleInitial());

  Future<void> fetchBundles() async {
    emit(BundleLoading());
    try {
      final bundles = await repository.fetchBundles();
      emit(BundleLoaded(bundles));
    } catch (e) {
      emit(BundleError(e.toString()));
    }
  }

  Future<void> deleteBundle(int bundleId) async {
    emit(BundleLoading());
    try {
      await repository.deleteBundle(bundleId);
      await fetchBundles();
    } catch (e) {
      emit(BundleError(e.toString()));
    }
  }
}
