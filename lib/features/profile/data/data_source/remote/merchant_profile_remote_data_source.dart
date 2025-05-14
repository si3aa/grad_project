import 'package:dio/dio.dart';
import 'package:Herfa/features/profile/data/models/merchant_profile_model.dart';

class MerchantProfileRemoteDataSource {
  final Dio dio;
  MerchantProfileRemoteDataSource(Dio dio)
      : dio = dio
          ..options.baseUrl = 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/';

  Future<MerchantProfileModel> fetchMerchantProfile(
      String token, int merchantId) async {
    final response = await dio.get(
      'profiles/merchant/$merchantId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return MerchantProfileModel.fromJson(response.data['data']);
  }
}
