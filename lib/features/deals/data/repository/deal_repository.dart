import '../models/deal_models.dart';
import '../data_source/deal_remote_data_source.dart';

class DealRepository {
  final DealRemoteDataSource remoteDataSource;
  DealRepository(this.remoteDataSource);

  Future<DealResponse> createDeal(String token, DealRequest request) {
    return remoteDataSource.createDeal(token, request);
  }

  Future<List<DealResponse>> getAllBuyerDeals(String token) {
    return remoteDataSource.getAllBuyerDeals(token);
  }

  Future<List<DealResponse>> getAllSellerDeals(String token) {
    return remoteDataSource.getAllSellerDeals(token);
  }

  Future<DealResponse> sellerAcceptDeal(String token, int dealId) {
    return remoteDataSource.sellerAcceptDeal(token, dealId);
  }

  Future<DealResponse> sellerRejectDeal(String token, int dealId) {
    return remoteDataSource.sellerRejectDeal(token, dealId);
  }

  Future<DealResponse> sellerCounterOffer(
      String token, int dealId, double counterPrice, int counterQuantity) {
    return remoteDataSource.sellerCounterOffer(
      token,
      dealId,
      counterPrice,
      counterQuantity,
    );
  }

  Future<DealResponse> buyerAcceptCounter(String token, int dealId) {
    return remoteDataSource.buyerAcceptCounter(token, dealId);
  }

  Future<DealResponse> buyerRejectCounter(String token, int dealId) {
    return remoteDataSource.buyerRejectCounter(token, dealId);
  }
}
