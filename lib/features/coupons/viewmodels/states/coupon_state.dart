import 'package:Herfa/features/coupons/data/models/coupon_model.dart';
import 'package:Herfa/features/coupons/data/models/coupon_response.dart';

abstract class CouponState {
  const CouponState();
}

class CouponInitial extends CouponState {
  const CouponInitial();
}

// States for creating a coupon
class CouponLoading extends CouponState {
  const CouponLoading();
}

class CouponSuccess extends CouponState {
  final CouponResponse response;

  const CouponSuccess(this.response);
}

class CouponError extends CouponState {
  final String message;

  const CouponError(this.message);
}

// States for fetching all coupons
class AllCouponsLoading extends CouponState {
  const AllCouponsLoading();
}

class AllCouponsLoaded extends CouponState {
  final List<CouponModel> coupons;
  const AllCouponsLoaded(this.coupons);
}

class AllCouponsError extends CouponState {
  final String message;
  const AllCouponsError(this.message);
}

// States for deleting a coupon
class DeleteCouponLoading extends CouponState {
  const DeleteCouponLoading();
}

class DeleteCouponSuccess extends CouponState {
  final CouponResponse response;
  const DeleteCouponSuccess(this.response);
}

class DeleteCouponError extends CouponState {
  final String message;
  const DeleteCouponError(this.message);
}
