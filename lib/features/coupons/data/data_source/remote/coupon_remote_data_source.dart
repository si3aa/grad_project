import 'package:dio/dio.dart';

import 'package:Herfa/features/coupons/data/models/coupon_model.dart';
import 'package:Herfa/features/coupons/data/models/coupon_request.dart';
import 'package:Herfa/features/coupons/data/models/coupon_response.dart';

abstract class CouponRemoteDataSource {
  Future<CouponResponse> createCoupon(CouponRequest request, String token);
  Future<List<CouponModel>> getAllCoupons(String token);
  Future<CouponResponse> deleteCoupon(String couponId, String token);
}

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  final Dio dio;

  CouponRemoteDataSourceImpl({required this.dio});

  @override
  Future<CouponResponse> createCoupon(
      CouponRequest request, String token) async {
    try {
      final response = await dio.post(
        '/coupons',
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return CouponResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to create coupon: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to create coupon: $e');
    }
  }

  @override
  Future<List<CouponModel>> getAllCoupons(String token) async {
    try {
      final response = await dio.get(
        '/coupons',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data['success'] == true && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((couponJson) => CouponModel.fromJson(couponJson))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch coupons');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to fetch coupons: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to fetch coupons: $e');
    }
  }

  @override
  Future<CouponResponse> deleteCoupon(String couponId, String token) async {
    try {
      final response = await dio.delete(
        '/coupons/$couponId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return CouponResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to delete coupon: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to delete coupon: $e');
    }
  }
}
