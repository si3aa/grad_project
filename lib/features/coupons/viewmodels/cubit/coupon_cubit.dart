import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/coupons/data/models/coupon_request.dart';

import 'package:Herfa/features/coupons/data/repository/coupon_repository.dart';
import 'package:Herfa/features/coupons/viewmodels/states/coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  final CouponRepository repository;

  CouponCubit({required this.repository}) : super(CouponInitial());

  Future<void> createCoupon(CouponRequest request) async {
    emit(CouponLoading());

    try {
      final response = await repository.createCoupon(request);

      if (response.success) {
        emit(CouponSuccess(response));
      } else {
        emit(CouponError(response.message));
      }
    } catch (e) {
      emit(CouponError('Failed to create coupon: $e'));
    }
  }

  Future<void> getAllCoupons() async {
    emit(AllCouponsLoading());
    try {
      final coupons = await repository.getAllCoupons();
      emit(AllCouponsLoaded(coupons));
    } catch (e) {
      emit(AllCouponsError('Failed to fetch coupons: $e'));
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    emit(DeleteCouponLoading());
    try {
      final response = await repository.deleteCoupon(couponId);
      if (response.success) {
        emit(DeleteCouponSuccess(response));
        // Refresh the coupons list after successful deletion
        getAllCoupons();
      } else {
        emit(DeleteCouponError(response.message));
      }
    } catch (e) {
      emit(DeleteCouponError('Failed to delete coupon: $e'));
    }
  }

  void resetState() {
    emit(CouponInitial());
  }
}
