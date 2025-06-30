import '../models/merchant_profile.dart';
import '../data_source/profile_remote_data_source.dart';
import 'dart:io';
import '../models/merchant_profile.dart' show UserProfile;
import '../models/profile_order_model.dart';
import '../models/refund_request_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepository(this.remoteDataSource);

  Future<MerchantProfile?> fetchProfile(String token, int userId) {
    return remoteDataSource.fetchProfile(token, userId);
  }

  Future<bool> createOrUpdateProfile(String token, Map<String, dynamic> data) {
    return remoteDataSource.createOrUpdateProfile(token, data);
  }

  Future<String?> uploadProfilePicture(String token, File imageFile) {
    return remoteDataSource.uploadProfilePicture(token, imageFile);
  }

  Future<UserProfile?> fetchUserProfile(String token, int userId) {
    return remoteDataSource.fetchUserProfile(token, userId);
  }

  Future<List<ProfileOrderModel>> fetchAllOrders(String token) {
    return remoteDataSource.fetchAllOrders(token);
  }

  Future<RefundRequestResponse> createRefundRequest(
    String token,
    int orderId,
    String reasonType,
    String message,
    List<String> imagePaths,
  ) {
    return remoteDataSource.createRefundRequest(
      token,
      orderId,
      reasonType,
      message,
      imagePaths,
    );
  }

  Future<List<RefundRequestModel>> fetchMyRefundRequests(String token) {
    return remoteDataSource.fetchMyRefundRequests(token);
  }
}
