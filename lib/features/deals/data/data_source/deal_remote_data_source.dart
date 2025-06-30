import 'package:dio/dio.dart';
import '../models/deal_models.dart';

class DealRemoteDataSource {
  final Dio dio;
  DealRemoteDataSource(this.dio);

  Future<DealResponse> createDeal(String token, DealRequest request) async {
    final response = await dio.post(
      '/deals',
      data: request.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return DealResponse.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to create deal');
    }
  }

  Future<List<DealResponse>> getAllBuyerDeals(String token) async {
    final response = await dio.get(
      '/deals/buyer',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List data = response.data['data'];
      return data.map((e) => DealResponse.fromJson(e)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch deals');
    }
  }

  Future<List<DealResponse>> getAllSellerDeals(String token) async {
    final response = await dio.get(
      '/deals/seller',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      final List data = response.data['data'];
      return data.map((e) => DealResponse.fromJson(e)).toList();
    } else {
      throw Exception(
          response.data['message'] ?? 'Failed to fetch seller deals');
    }
  }

  Future<DealResponse> sellerAcceptDeal(String token, int dealId) async {
    final response = await dio.patch(
      '/deals/$dealId/seller/accept',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return DealResponse.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to accept deal');
    }
  }

  Future<DealResponse> sellerRejectDeal(String token, int dealId) async {
    final response = await dio.patch(
      '/deals/$dealId/seller/reject',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return DealResponse.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to reject deal');
    }
  }

  Future<DealResponse> sellerCounterOffer(String token, int dealId,
      double counterPrice, int counterQuantity) async {
    // Use a new Dio instance to avoid interceptors for this request
    final Dio directDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
    final response = await directDio.patch(
      '/deals/$dealId/counter',
      data: {
        'dealId': dealId,
        'counterPrice': counterPrice,
        'counterQuantity': counterQuantity,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    print('Request URL: /deals/$dealId/counter');
    print('Headers: \\${response.requestOptions.headers}');
    print('Body: \\${response.requestOptions.data}');
    print('Status: \\${response.statusCode}');
    print('Response: \\${response.data}');
    if (response.data['success'] == true) {
      return DealResponse.fromJson(response.data['data']);
    } else {
      throw Exception(
          response.data['message'] ?? 'Failed to propose counter offer');
    }
  }

  Future<DealResponse> buyerAcceptCounter(String token, int dealId) async {
    final response = await dio.patch(
      '/deals/$dealId/buyer/accept',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return DealResponse.fromJson(response.data['data']);
    } else {
      throw Exception(
          response.data['message'] ?? 'Failed to accept counter offer');
    }
  }

  Future<DealResponse> buyerRejectCounter(String token, int dealId) async {
    final response = await dio.patch(
      '/deals/$dealId/buyer/reject',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data['success'] == true) {
      return DealResponse.fromJson(response.data['data']);
    } else {
      throw Exception(
          response.data['message'] ?? 'Failed to reject counter offer');
    }
  }
}
