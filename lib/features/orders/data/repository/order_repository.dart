import '../models/order_model.dart';
import '../data_source/order_remote_data_source.dart';

abstract class OrderRepository {
  Future<OrderModel> makeOrder(
      {required List<OrderItemModel> items, required String token});
  Future<bool> payOrder({required int orderId, required String token});
  Future<double> getBalance({required String token});
  Future<String> rechargeWallet(
      {required double amount, required String token});
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderModel> makeOrder(
      {required List<OrderItemModel> items, required String token}) {
    return remoteDataSource.makeOrder(items: items, token: token);
  }

  @override
  Future<bool> payOrder({required int orderId, required String token}) {
    return remoteDataSource.payOrder(orderId: orderId, token: token);
  }

  @override
  Future<double> getBalance({required String token}) {
    return remoteDataSource.getBalance(token: token);
  }

  @override
  Future<String> rechargeWallet(
      {required double amount, required String token}) {
    return remoteDataSource.rechargeWallet(amount: amount, token: token);
  }
}
