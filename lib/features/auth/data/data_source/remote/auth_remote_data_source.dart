import 'package:Herfa/features/auth/data/models/login_request.dart';
import 'package:Herfa/features/auth/data/models/login_response.dart';
import 'package:Herfa/features/auth/data/models/register_request.dart';
import 'package:Herfa/features/auth/data/models/register_response.dart';
import 'package:Herfa/features/auth/data/models/verify_response.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<VerifyResponse> verifyOTP(String email, String otp);
}
