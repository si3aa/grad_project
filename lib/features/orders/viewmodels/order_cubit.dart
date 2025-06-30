import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/order_model.dart';
import '../data/repository/order_repository.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;
  OrderCubit({required this.repository}) : super(OrderInitial());

  Future<void> makeOrder(
      {required List<OrderItemModel> items, required String token}) async {
    emit(OrderLoading());
    try {
      final order = await repository.makeOrder(items: items, token: token);
      emit(OrderSuccess(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> payOrder({required int orderId, required String token}) async {
    emit(OrderPaying());
    try {
      final paid = await repository.payOrder(orderId: orderId, token: token);
      if (paid) {
        emit(OrderPaid());
      } else {
        emit(OrderError('Payment failed'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> checkBalanceAndPay(
      {required int orderId,
      required double total,
      required String token}) async {
    emit(OrderCheckingBalance());
    try {
      final balance = await repository.getBalance(token: token);
      if (balance >= total) {
        await payOrder(orderId: orderId, token: token);
      } else {
        emit(OrderInsufficientBalance(balance));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> rechargeWallet(
      {required double amount, required String token}) async {
    emit(OrderRechargingWallet());
    try {
      final url = await repository.rechargeWallet(amount: amount, token: token);
      emit(OrderRechargeUrl(url));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
