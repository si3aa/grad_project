class BundleModel {
  final int id;
  final String name;
  final String description;
  final double bundlePrice;
  final bool active;
  final DateTime createdAt;
  final List<BundleProduct> products;

  BundleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.bundlePrice,
    required this.active,
    required this.createdAt,
    required this.products,
  });

  factory BundleModel.fromJson(Map<String, dynamic> json) {
    return BundleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      bundlePrice: (json['bundlePrice'] as num).toDouble(),
      active: json['active'],
      createdAt: DateTime.parse(json['createdAt']),
      products: (json['products'] as List)
          .map((e) => BundleProduct.fromJson(e))
          .toList(),
    );
  }
}

class BundleProduct {
  final int productId;
  final String productName;
  final int quantity;

  BundleProduct({
    required this.productId,
    required this.productName,
    required this.quantity,
  });

  factory BundleProduct.fromJson(Map<String, dynamic> json) {
    return BundleProduct(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
    );
  }
}
