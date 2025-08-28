import 'dart:convert';

enum UserType { client, supplier, driver, admin }

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserType userType;
  final String phone;
  final String? address;
  final String? city;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? metadata;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
    required this.phone,
    this.address,
    this.city,
    this.isVerified = false,
    this.isActive = true,
    DateTime? createdAt,
    this.lastLoginAt,
    this.metadata,
  }) : createdAt = createdAt ?? DateTime.now();

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserType? userType,
    String? phone,
    String? address,
    String? city,
    bool? isVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'userType': userType.toString().split('.').last,
      'phone': phone,
      'address': address,
      'city': city,
      'isVerified': isVerified,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      userType: UserType.values.firstWhere(
        (e) => e.toString().split('.').last == json['userType'],
      ),
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      metadata: json['metadata'],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
