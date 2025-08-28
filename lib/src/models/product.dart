import 'package:flutter/material.dart';

class Product {
  final String id;
  final String supplierId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final String category;
  final int stockQuantity;
  final String unit;
  final String imageUrl;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final double? discountPercentage;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.supplierId,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.category,
    required this.stockQuantity,
    required this.unit,
    required this.imageUrl,
    required this.isAvailable,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.discountPercentage,
    this.discountStartDate,
    this.discountEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      supplierId: json['supplierId'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      stockQuantity: json['stockQuantity'] ?? 0,
      unit: json['unit'] ?? 'قطعة',
      imageUrl: json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      discountPercentage: json['discountPercentage']?.toDouble(),
      discountStartDate: json['discountStartDate'] != null
          ? DateTime.parse(json['discountStartDate'])
          : null,
      discountEndDate: json['discountEndDate'] != null
          ? DateTime.parse(json['discountEndDate'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierId': supplierId,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'price': price,
      'category': category,
      'stockQuantity': stockQuantity,
      'unit': unit,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'discountPercentage': discountPercentage,
      'discountStartDate': discountStartDate?.toIso8601String(),
      'discountEndDate': discountEndDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String getLocalizedName(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? nameAr : nameEn;
  }

  String getLocalizedDescription(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
  }

  double get finalPrice {
    if (hasDiscount) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }

  bool get hasDiscount {
    if (discountPercentage != null &&
        discountStartDate != null &&
        discountEndDate != null) {
      final now = DateTime.now();
      return now.isAfter(discountStartDate!) && now.isBefore(discountEndDate!);
    }
    return false;
  }

  bool get inStock => stockQuantity > 0 && isAvailable;

  Product copyWith({
    String? id,
    String? supplierId,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    double? price,
    String? category,
    int? stockQuantity,
    String? unit,
    String? imageUrl,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    double? discountPercentage,
    DateTime? discountStartDate,
    DateTime? discountEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      price: price ?? this.price,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountStartDate: discountStartDate ?? this.discountStartDate,
      discountEndDate: discountEndDate ?? this.discountEndDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Product Categories
class ProductCategory {
  static const String cement = 'cement';
  static const String steel = 'steel';
  static const String bricks = 'bricks';
  static const String tiles = 'tiles';
  static const String tools = 'tools';
  static const String electrical = 'electrical';
  static const String plumbing = 'plumbing';
  static const String paint = 'paint';
  static const String wood = 'wood';
  static const String glass = 'glass';
  static const String insulation = 'insulation';
  static const String hardware = 'hardware';

  static const List<String> all = [
    cement,
    steel,
    bricks,
    tiles,
    tools,
    electrical,
    plumbing,
    paint,
    wood,
    glass,
    insulation,
    hardware,
  ];

  static const Map<String, Map<String, String>> names = {
    cement: {'ar': 'أسمنت', 'en': 'Cement'},
    steel: {'ar': 'حديد', 'en': 'Steel'},
    bricks: {'ar': 'طوب', 'en': 'Bricks'},
    tiles: {'ar': 'بلاط', 'en': 'Tiles'},
    tools: {'ar': 'أدوات', 'en': 'Tools'},
    electrical: {'ar': 'كهربائيات', 'en': 'Electrical'},
    plumbing: {'ar': 'سباكة', 'en': 'Plumbing'},
    paint: {'ar': 'دهانات', 'en': 'Paint'},
    wood: {'ar': 'خشب', 'en': 'Wood'},
    glass: {'ar': 'زجاج', 'en': 'Glass'},
    insulation: {'ar': 'عزل', 'en': 'Insulation'},
    hardware: {'ar': 'أدوات معدنية', 'en': 'Hardware'},
  };
}
