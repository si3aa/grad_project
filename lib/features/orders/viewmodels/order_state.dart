part of 'order_cubit.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final OrderModel order;
  OrderSuccess(this.order);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

// Payment states
class OrderPaying extends OrderState {}

class OrderPaid extends OrderState {}

class OrderCheckingBalance extends OrderState {}

class OrderInsufficientBalance extends OrderState {
  final double balance;
  OrderInsufficientBalance(this.balance);
}

class OrderRechargingWallet extends OrderState {}

class OrderRechargeUrl extends OrderState {
  final String url;
  OrderRechargeUrl(this.url);
}
