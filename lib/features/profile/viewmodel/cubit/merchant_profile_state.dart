part of 'merchant_profile_cubit.dart';

abstract class MerchantProfileState {}

class MerchantProfileInitial extends MerchantProfileState {}

class MerchantProfileLoading extends MerchantProfileState {}

class MerchantProfileLoaded extends MerchantProfileState {
  final MerchantProfileModel profile;
  MerchantProfileLoaded(this.profile);
}

class MerchantProfileError extends MerchantProfileState {
  final String message;
  MerchantProfileError(this.message);
}
