part of 'bundle_cubit.dart';

abstract class BundleState {}

class BundleInitial extends BundleState {}

class BundleLoading extends BundleState {}

class BundleLoaded extends BundleState {
  final List<BundleModel> bundles;
  BundleLoaded(this.bundles);
}

class BundleError extends BundleState {
  final String message;
  BundleError(this.message);
}
