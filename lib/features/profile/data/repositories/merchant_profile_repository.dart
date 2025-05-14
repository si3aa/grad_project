import 'package:Herfa/features/profile/data/data_source/remote/merchant_profile_remote_data_source.dart';
import 'package:Herfa/features/profile/data/models/merchant_profile_model.dart';

class MerchantProfileRepository {
  final MerchantProfileRemoteDataSource remoteDataSource;
  MerchantProfileRepository(this.remoteDataSource);

  Future<MerchantProfileModel> fetchMerchantProfile(
      String token, int merchantId) {
    return remoteDataSource.fetchMerchantProfile(token, merchantId);
  }
}
