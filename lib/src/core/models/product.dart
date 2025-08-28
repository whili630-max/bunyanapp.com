import 'dart:convert';

class Product {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final String category;
  final String supplierId;
  final int stockQuantity;
  final String unit;
  final String? imageUrl;
  final List<String> images;
  final bool isAvailable;
  final double? discountPercentage;
  final double? weight;
  final Map<String, dynamic>? specifications;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int viewCount;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.category,
    required this.supplierId,
    required this.stockQuantity,
    required this.unit,
    this.imageUrl,
    this.images = const [],
    this.isAvailable = true,
    this.discountPercentage,
    this.weight,
    this.specifications,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.viewCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Product copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    double? price,
    String? category,
    String? supplierId,
    int? stockQuantity,
    String? unit,
    String? imageUrl,
    List<String>? images,
    bool? isAvailable,
    double? discountPercentage,
    double? weight,
    Map<String, dynamic>? specifications,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? viewCount,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      price: price ?? this.price,
      category: category ?? this.category,
      supplierId: supplierId ?? this.supplierId,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      weight: weight ?? this.weight,
      specifications: specifications ?? this.specifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewCount: viewCount ?? this.viewCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  double get finalPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      return price * (1 - discountPercentage! / 100);
    }
    return price;
  }

  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;

  bool get inStock => stockQuantity > 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'price': price,
      'category': category,
      'supplierId': supplierId,
      'stockQuantity': stockQuantity,
      'unit': unit,
      'imageUrl': imageUrl,
      'images': images,
      'isAvailable': isAvailable,
      'discountPercentage': discountPercentage,
      'weight': weight,
      'specifications': specifications,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'viewCount': viewCount,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      descriptionAr: json['descriptionAr'],
      descriptionEn: json['descriptionEn'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      supplierId: json['supplierId'],
      stockQuantity: json['stockQuantity'],
      unit: json['unit'],
      imageUrl: json['imageUrl'],
      images: List<String>.from(json['images'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      discountPercentage: json['discountPercentage']?.toDouble(),
      weight: json['weight']?.toDouble(),
      specifications: json['specifications'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      viewCount: json['viewCount'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, nameAr: $nameAr, nameEn: $nameEn, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Product Categories
class ProductCategory {
  static const String cement = 'cement';
  static const String steel = 'steel';
  static const String bricks = 'bricks';
  static const String tiles = 'tiles';
  static const String sand = 'sand';
  static const String gravel = 'gravel';
  static const String tools = 'tools';
  static const String electrical = 'electrical';
  static const String plumbing = 'plumbing';
  static const String paint = 'paint';
  static const String insulation = 'insulation';
  static const String flooring = 'flooring';

  static List<String> get all => [
        cement,
        steel,
        bricks,
        tiles,
        sand,
        gravel,
        tools,
        electrical,
        plumbing,
        paint,
        insulation,
        flooring,
      ];

  static Map<String, Map<String, String>> get names => {
        cement: {'ar': 'أسمنت', 'en': 'Cement'},
        steel: {'ar': 'حديد', 'en': 'Steel'},
        bricks: {'ar': 'طوب', 'en': 'Bricks'},
        tiles: {'ar': 'بلاط', 'en': 'Tiles'},
        sand: {'ar': 'رمل', 'en': 'Sand'},
        gravel: {'ar': 'حصى', 'en': 'Gravel'},
        tools: {'ar': 'أدوات', 'en': 'Tools'},
        electrical: {'ar': 'كهربائيات', 'en': 'Electrical'},
        plumbing: {'ar': 'سباكة', 'en': 'Plumbing'},
        paint: {'ar': 'دهان', 'en': 'Paint'},
        insulation: {'ar': 'عزل', 'en': 'Insulation'},
        flooring: {'ar': 'أرضيات', 'en': 'Flooring'},
      };
}
