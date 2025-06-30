// Order models for API integration
class OrderItemModel {
  final int productId;
  final int quantity;
  final String? couponCode;

  OrderItemModel({
    required this.productId,
    required this.quantity,
    this.couponCode,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
        'couponCode': couponCode,
      };
}

class OrderModel {
  final int id;
  final String orderDate;
  final double totalPrice;
  final String status;
  final List<OrderDetailModel> orderDetails;
  final List<dynamic> appliedOffers;

  OrderModel({
    required this.id,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    required this.orderDetails,
    required this.appliedOffers,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'],
        orderDate: json['orderDate'],
        totalPrice: (json['totalPrice'] as num).toDouble(),
        status: json['status'],
        orderDetails: (json['orderDetails'] as List)
            .map((e) => OrderDetailModel.fromJson(e))
            .toList(),
        appliedOffers: json['appliedOffers'] ?? [],
      );
}

class OrderDetailModel {
  final int id;
  final ProductSummary product;
  final String? couponCode;
  final int quantity;
  final double unitPrice;

  OrderDetailModel({
    required this.id,
    required this.product,
    this.couponCode,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        id: json['id'],
        product: ProductSummary.fromJson(json['product']),
        couponCode: json['couponCode'],
        quantity: json['quantity'],
        unitPrice: (json['unitPrice'] as num).toDouble(),
      );
}

class ProductSummary {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final double price;
  final int quantity;
  final bool active;
  final double discountedPrice;

  ProductSummary({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.quantity,
    required this.active,
    required this.discountedPrice,
  });

  factory ProductSummary.fromJson(Map<String, dynamic> json) => ProductSummary(
        id: json['id'],
        name: json['name'],
        shortDescription: json['shortDescription'],
        longDescription: json['longDescription'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'],
        active: json['active'],
        discountedPrice: (json['discountedPrice'] as num).toDouble(),
      );
}
