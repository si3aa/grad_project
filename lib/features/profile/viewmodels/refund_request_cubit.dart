import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/profile_repository.dart';
import '../data/models/refund_request_model.dart';
import '../data/models/profile_order_model.dart';

// States
abstract class RefundRequestState {}

class RefundRequestInitial extends RefundRequestState {}

class RefundRequestLoading extends RefundRequestState {}

class RefundRequestSuccess extends RefundRequestState {
  final RefundRequestModel refundRequest;
  final String message;

  RefundRequestSuccess({
    required this.refundRequest,
    required this.message,
  });
}

class RefundRequestError extends RefundRequestState {
  final String message;

  RefundRequestError(this.message);
}

class OrdersLoading extends RefundRequestState {}

class OrdersLoaded extends RefundRequestState {
  final List<ProfileOrderModel> paidOrders;

  OrdersLoaded(this.paidOrders);
}

class OrdersError extends RefundRequestState {
  final String message;

  OrdersError(this.message);
}

class MyRefundRequestsLoading extends RefundRequestState {}

class MyRefundRequestsLoaded extends RefundRequestState {
  final List<RefundRequestModel> refunds;
  MyRefundRequestsLoaded(this.refunds);
}

class MyRefundRequestsError extends RefundRequestState {
  final String message;
  MyRefundRequestsError(this.message);
}

// Cubit
class RefundRequestCubit extends Cubit<RefundRequestState> {
  final ProfileRepository repository;

  RefundRequestCubit(this.repository) : super(RefundRequestInitial());

  Future<void> fetchPaidOrders(String token) async {
    emit(OrdersLoading());
    try {
      final allOrders = await repository.fetchAllOrders(token);
      final paidOrders =
          allOrders.where((order) => order.status == 'PAID').toList();
      emit(OrdersLoaded(paidOrders));
    } catch (e) {
      emit(OrdersError('Failed to load orders: $e'));
    }
  }

  Future<void> createRefundRequest({
    required String token,
    required int orderId,
    required String reasonType,
    required String message,
    required List<String> imagePaths,
  }) async {
    emit(RefundRequestLoading());

    try {
      final response = await repository.createRefundRequest(
        token,
        orderId,
        reasonType,
        message,
        imagePaths,
      );

      if (response.success && response.data != null) {
        emit(RefundRequestSuccess(
          refundRequest: response.data!,
          message: response.message,
        ));
      } else {
        emit(RefundRequestError(response.message));
      }
    } catch (e) {
      emit(RefundRequestError('Failed to create refund request: $e'));
    }
  }

  Future<void> fetchMyRefundRequests(String token) async {
    emit(MyRefundRequestsLoading());
    try {
      final refunds = await repository.fetchMyRefundRequests(token);
      emit(MyRefundRequestsLoaded(refunds));
    } catch (e) {
      emit(MyRefundRequestsError('Failed to load refund requests: $e'));
    }
  }

  void reset() {
    emit(RefundRequestInitial());
  }
}
