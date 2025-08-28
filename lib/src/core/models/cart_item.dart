import 'dart:convert';

class CartItem {
  final String productId;
  final String productName;
  final String productNameAr;
  final double price;
  final int quantity;
  final String unit;
  final String category;
  final String supplierId;
  final String supplierName;
  final String? imageUrl;
  final int maxStock;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productNameAr,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.supplierId,
    required this.supplierName,
    this.imageUrl,
    required this.maxStock,
  });

  double get total => price * quantity;

  bool get isMaxQuantity => quantity >= maxStock;

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productNameAr,
    double? price,
    int? quantity,
    String? unit,
    String? category,
    String? supplierId,
    String? supplierName,
    String? imageUrl,
    int? maxStock,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productNameAr: productNameAr ?? this.productNameAr,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      imageUrl: imageUrl ?? this.imageUrl,
      maxStock: maxStock ?? this.maxStock,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productNameAr': productNameAr,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'imageUrl': imageUrl,
      'maxStock': maxStock,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      productName: json['productName'],
      productNameAr: json['productNameAr'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      unit: json['unit'],
      category: json['category'],
      supplierId: json['supplierId'],
      supplierName: json['supplierName'],
      imageUrl: json['imageUrl'],
      maxStock: json['maxStock'],
    );
  }

  @override
  String toString() {
    return 'CartItem(productId: $productId, quantity: $quantity, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;
}
