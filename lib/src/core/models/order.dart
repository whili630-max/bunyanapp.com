import 'dart:convert';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String unit;
  final double total;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'total': total,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      unit: json['unit'],
      total: (json['total'] as num).toDouble(),
    );
  }
}

class Order {
  final String id;
  final String customerId;
  final String customerName;
  final String supplierId;
  final String supplierName;
  final List<OrderItem> items;
  final double subtotal;
  final double taxAmount;
  final double deliveryFee;
  final double totalAmount;
  final OrderStatus status;
  final String deliveryAddress;
  final String? deliveryNotes;
  final String? driverId;
  final String? driverName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;
  final String? trackingNumber;
  final Map<String, dynamic>? metadata;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.supplierId,
    required this.supplierName,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.deliveryFee,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    required this.deliveryAddress,
    this.deliveryNotes,
    this.driverId,
    this.driverName,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deliveredAt,
    this.trackingNumber,
    this.metadata,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Order copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? supplierId,
    String? supplierName,
    List<OrderItem>? items,
    double? subtotal,
    double? taxAmount,
    double? deliveryFee,
    double? totalAmount,
    OrderStatus? status,
    String? deliveryAddress,
    String? deliveryNotes,
    String? driverId,
    String? driverName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
    String? trackingNumber,
    Map<String, dynamic>? metadata,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get canBeCancelled =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  bool get isCompleted => status == OrderStatus.delivered;

  bool get isActive =>
      status != OrderStatus.cancelled &&
      status != OrderStatus.delivered &&
      status != OrderStatus.refunded;

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'في الانتظار';
      case OrderStatus.confirmed:
        return 'مؤكد';
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.cancelled:
        return 'ملغي';
      case OrderStatus.refunded:
        return 'مسترد';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'deliveryAddress': deliveryAddress,
      'deliveryNotes': deliveryNotes,
      'driverId': driverId,
      'driverName': driverName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'metadata': metadata,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      supplierId: json['supplierId'],
      supplierName: json['supplierName'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      deliveryAddress: json['deliveryAddress'],
      deliveryNotes: json['deliveryNotes'],
      driverId: json['driverId'],
      driverName: json['driverName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
      trackingNumber: json['trackingNumber'],
      metadata: json['metadata'],
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, customerId: $customerId, status: $status, total: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
