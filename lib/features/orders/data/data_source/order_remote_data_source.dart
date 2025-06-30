import 'package:dio/dio.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> makeOrder(
      {required List<OrderItemModel> items, required String token});
  Future<bool> payOrder({required int orderId, required String token});
  Future<double> getBalance({required String token});
  Future<String> rechargeWallet(
      {required double amount, required String token});
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<OrderModel> makeOrder(
      {required List<OrderItemModel> items, required String token}) async {
    try {
      print('[OrderRemoteDataSource] Sending order request:');
      print('  items: ' + items.map((e) => e.toJson()).toList().toString());
      print('  token: $token');
      final response = await dio.post(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/orders',
        data: {'items': items.map((e) => e.toJson()).toList()},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(
          '[OrderRemoteDataSource] Response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        print('[OrderRemoteDataSource] Error: ${response.data['message']}');
        throw Exception(response.data['message'] ?? 'Order failed');
      }
    } catch (e, stack) {
      print('[OrderRemoteDataSource] Exception: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Future<bool> payOrder({required int orderId, required String token}) async {
    try {
      final response = await dio.post(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/orders/pay/$orderId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(
          '[OrderRemoteDataSource] PayOrder Response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Payment failed');
      }
    } catch (e, stack) {
      print('[OrderRemoteDataSource] PayOrder Exception: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Future<double> getBalance({required String token}) async {
    try {
      final response = await dio.get(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/auth/getBalance',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(
          '[OrderRemoteDataSource] GetBalance Response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return (response.data['data'] as num).toDouble();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get balance');
      }
    } catch (e, stack) {
      print('[OrderRemoteDataSource] GetBalance Exception: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Future<String> rechargeWallet(
      {required double amount, required String token}) async {
    try {
      final response = await dio.post(
        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app/payment/wallet/recharge?amount=$amount',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(
          '[OrderRemoteDataSource] RechargeWallet Response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200 && response.data['url'] != null) {
        return response.data['url'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to recharge wallet');
      }
    } catch (e, stack) {
      print('[OrderRemoteDataSource] RechargeWallet Exception: $e');
      print(stack);
      rethrow;
    }
  }
}
