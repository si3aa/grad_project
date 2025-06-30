import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/deal_models.dart';
import '../data/repository/deal_repository.dart';
import 'package:dio/dio.dart';

abstract class DealState {}

class DealInitial extends DealState {}

class DealLoading extends DealState {}

class DealSuccess extends DealState {
  final DealResponse response;
  DealSuccess(this.response);
}

class DealError extends DealState {
  final String message;
  DealError(this.message);
}

class BuyerDealsState {}

class BuyerDealsInitial extends BuyerDealsState {}

class BuyerDealsLoading extends BuyerDealsState {}

class BuyerDealsLoaded extends BuyerDealsState {
  final List<DealResponse> deals;
  BuyerDealsLoaded(this.deals);
}

class BuyerDealsError extends BuyerDealsState {
  final String message;
  BuyerDealsError(this.message);
}

class SellerDealsState {}

class SellerDealsInitial extends SellerDealsState {}

class SellerDealsLoading extends SellerDealsState {}

class SellerDealsLoaded extends SellerDealsState {
  final List<DealResponse> deals;
  SellerDealsLoaded(this.deals);
}

class SellerDealsError extends SellerDealsState {
  final String message;
  SellerDealsError(this.message);
}

class DealCubit extends Cubit<DealState> {
  final DealRepository repository;
  DealCubit(this.repository) : super(DealInitial());

  Future<void> createDeal(String token, DealRequest request) async {
    emit(DealLoading());
    try {
      final response = await repository.createDeal(token, request);
      emit(DealSuccess(response));
    } catch (e) {
      emit(DealError(e.toString()));
    }
  }
}

class BuyerDealsCubit extends Cubit<BuyerDealsState> {
  final DealRepository repository;
  BuyerDealsCubit(this.repository) : super(BuyerDealsInitial());

  Future<void> fetchAllBuyerDeals(String token) async {
    emit(BuyerDealsLoading());
    try {
      final deals = await repository.getAllBuyerDeals(token);
      emit(BuyerDealsLoaded(deals));
    } catch (e) {
      emit(BuyerDealsError(e.toString()));
    }
  }

  Future<void> acceptCounter(String token, int dealId) async {
    emit(BuyerDealsLoading());
    try {
      await repository.buyerAcceptCounter(token, dealId);
      await fetchAllBuyerDeals(token);
    } catch (e) {
      emit(BuyerDealsError(e.toString()));
    }
  }

  Future<void> rejectCounter(String token, int dealId) async {
    emit(BuyerDealsLoading());
    try {
      await repository.buyerRejectCounter(token, dealId);
      await fetchAllBuyerDeals(token);
    } catch (e) {
      emit(BuyerDealsError(e.toString()));
    }
  }
}

class SellerDealsCubit extends Cubit<SellerDealsState> {
  final DealRepository repository;
  SellerDealsCubit(this.repository) : super(SellerDealsInitial());

  Future<void> fetchAllSellerDeals(String token) async {
    emit(SellerDealsLoading());
    try {
      final deals = await repository.getAllSellerDeals(token);
      emit(SellerDealsLoaded(deals));
    } catch (e) {
      emit(SellerDealsError(e.toString()));
    }
  }

  Future<void> acceptDeal(String token, int dealId) async {
    emit(SellerDealsLoading());
    try {
      await repository.sellerAcceptDeal(token, dealId);
      await fetchAllSellerDeals(token);
    } catch (e) {
      if (e is DioError) {
        print('Dio error: \\${e.response?.statusCode} \\${e.response?.data}');
        emit(SellerDealsError(
            'Error: \\${e.response?.statusCode} \\${e.response?.data}'));
      } else {
        print('Error: \\${e.toString()}');
        emit(SellerDealsError(e.toString()));
      }
    }
  }

  Future<void> rejectDeal(String token, int dealId) async {
    emit(SellerDealsLoading());
    try {
      await repository.sellerRejectDeal(token, dealId);
      await fetchAllSellerDeals(token);
    } catch (e) {
      if (e is DioError) {
        print('Dio error: \\${e.response?.statusCode} \\${e.response?.data}');
        emit(SellerDealsError(
            'Error: \\${e.response?.statusCode} \\${e.response?.data}'));
      } else {
        print('Error: \\${e.toString()}');
        emit(SellerDealsError(e.toString()));
      }
    }
  }

  Future<void> counterOffer(String token, int dealId, double counterPrice,
      int counterQuantity) async {
    emit(SellerDealsLoading());
    try {
      await repository.sellerCounterOffer(
          token, dealId, counterPrice, counterQuantity);
      await fetchAllSellerDeals(token);
    } catch (e) {
      if (e is DioError) {
        print('Dio error: \\${e.response?.statusCode} \\${e.response?.data}');
        emit(SellerDealsError(
            'Error: \\${e.response?.statusCode} \\${e.response?.data}'));
      } else {
        print('Error: \\${e.toString()}');
        emit(SellerDealsError(e.toString()));
      }
    }
  }
}
