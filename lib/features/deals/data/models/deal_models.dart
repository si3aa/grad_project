class DealRequest {
  final int productId;
  final double proposedPrice;
  final int requestedQuantity;

  DealRequest({
    required this.productId,
    required this.proposedPrice,
    required this.requestedQuantity,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'proposedPrice': proposedPrice,
        'requestedQuantity': requestedQuantity,
      };
}

class DealProduct {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final double price;
  final int quantity;
  final String media;
  final bool active;
  final List<String> colors;
  final double discountedPrice;

  DealProduct({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.quantity,
    required this.media,
    required this.active,
    required this.colors,
    required this.discountedPrice,
  });

  factory DealProduct.fromJson(Map<String, dynamic> json) => DealProduct(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        shortDescription: json['shortDescription'] ?? '',
        longDescription: json['longDescription'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        quantity: json['quantity'] ?? 0,
        media: json['media'] ?? '',
        active: json['active'] ?? false,
        colors: (json['colors'] as List?)
                ?.map(
                    (c) => c.toString().replaceAll('[', '').replaceAll(']', ''))
                .toList() ??
            [],
        discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      );
}

class DealResponse {
  final int id;
  final String buyerUsername;
  final DealProduct product;
  final int requestedQuantity;
  final double proposedPrice;
  final double? counterPrice;
  final int? counterQuantity;
  final String status;
  final String createdAt;
  final String updatedAt;

  DealResponse({
    required this.id,
    required this.buyerUsername,
    required this.product,
    required this.requestedQuantity,
    required this.proposedPrice,
    this.counterPrice,
    this.counterQuantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DealResponse.fromJson(Map<String, dynamic> json) => DealResponse(
        id: json['id'] ?? 0,
        buyerUsername: json['buyerUsername'] ?? '',
        product: DealProduct.fromJson(json['product'] ?? {}),
        requestedQuantity: json['requestedQuantity'] ?? 0,
        proposedPrice: (json['proposedPrice'] ?? 0).toDouble(),
        counterPrice: json['counterPrice'] != null
            ? (json['counterPrice'] as num).toDouble()
            : null,
        counterQuantity: json['counterQuantity'],
        status: json['status'] ?? '',
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
      );
}
