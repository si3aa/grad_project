import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/profile_order_model.dart';
import '../data/repository/profile_repository.dart';

abstract class OrderHistoryState {}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<ProfileOrderModel> orders;
  OrderHistoryLoaded(this.orders);
}

class OrderHistoryError extends OrderHistoryState {
  final String message;
  OrderHistoryError(this.message);
}

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final ProfileRepository repository;
  OrderHistoryCubit(this.repository) : super(OrderHistoryInitial());

  Future<void> fetchAllOrders(String token) async {
    emit(OrderHistoryLoading());
    try {
      final orders = await repository.fetchAllOrders(token);
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      emit(OrderHistoryError(e.toString()));
    }
  }
}
