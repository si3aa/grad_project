import 'package:Herfa/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:Herfa/features/coupons/data/data_source/remote/coupon_remote_data_source.dart';
import 'package:Herfa/features/coupons/data/models/coupon_model.dart';
import 'package:Herfa/features/coupons/data/models/coupon_request.dart';
import 'package:Herfa/features/coupons/data/models/coupon_response.dart';

abstract class CouponRepository {
  Future<CouponResponse> createCoupon(CouponRequest request);
  Future<List<CouponModel>> getAllCoupons();
  Future<CouponResponse> deleteCoupon(String couponId);
}

class CouponRepositoryImpl implements CouponRepository {
  final CouponRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  CouponRepositoryImpl(
      {required this.remoteDataSource, required this.authLocalDataSource});

  @override
  Future<CouponResponse> createCoupon(CouponRequest request) async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        throw Exception('Not authenticated. Please login first.');
      }
      final response = await remoteDataSource.createCoupon(request, token);
      return response;
    } catch (e) {
      return CouponResponse(
        success: false,
        message: 'Failed to create coupon: $e',
      );
    }
  }

  @override
  Future<List<CouponModel>> getAllCoupons() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        throw Exception('Not authenticated. Please login first.');
      }
      return await remoteDataSource.getAllCoupons(token);
    } catch (e) {
      // In case of error, rethrow the exception to be handled by the Cubit
      rethrow;
    }
  }

  @override
  Future<CouponResponse> deleteCoupon(String couponId) async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        throw Exception('Not authenticated. Please login first.');
      }
      final response = await remoteDataSource.deleteCoupon(couponId, token);
      return response;
    } catch (e) {
      return CouponResponse(
        success: false,
        message: 'Failed to delete coupon: $e',
      );
    }
  }
}
