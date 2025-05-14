import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/profile/data/models/merchant_profile_model.dart';
import 'package:Herfa/features/profile/data/repositories/merchant_profile_repository.dart';

part 'merchant_profile_state.dart';

class MerchantProfileCubit extends Cubit<MerchantProfileState> {
  final MerchantProfileRepository repository;
  MerchantProfileCubit(this.repository) : super(MerchantProfileInitial());

  Future<void> fetchMerchantProfile(String token, int merchantId) async {
    emit(MerchantProfileLoading());
    try {
      final profile = await repository.fetchMerchantProfile(token, merchantId);
      emit(MerchantProfileLoaded(profile));
    } catch (e) {
      emit(MerchantProfileError(e.toString()));
    }
  }
}
