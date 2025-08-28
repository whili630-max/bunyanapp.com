import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/user.dart';

class CartService extends ChangeNotifier {
  static CartService? _instance;
  static CartService get instance => _instance ??= CartService._();
  CartService._();

  SharedPreferences? _prefs;
  List<CartItem> _items = [];
  String? _currentUserId;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.total);
  double get taxAmount => subtotal * 0.15; // 15% VAT
  double get deliveryFee => _items.isEmpty ? 0.0 : 50.0; // Fixed delivery fee
  double get totalAmount => subtotal + taxAmount + deliveryFee;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  // Group items by supplier
  Map<String, List<CartItem>> get itemsBySupplier {
    final Map<String, List<CartItem>> grouped = {};
    for (final item in _items) {
      if (!grouped.containsKey(item.supplierId)) {
        grouped[item.supplierId] = [];
      }
      grouped[item.supplierId]!.add(item);
    }
    return grouped;
  }

  Future<void> initialize(String userId) async {
    _currentUserId = userId;
    _prefs = await SharedPreferences.getInstance();
    await _loadCart();
  }

  Future<void> _loadCart() async {
    if (_currentUserId == null) return;

    final cartJson = _prefs?.getStringList('cart_$_currentUserId') ?? [];
    _items =
        cartJson.map((json) => CartItem.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    if (_currentUserId == null) return;

    final cartJson = _items.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs?.setStringList('cart_$_currentUserId', cartJson);
  }

  Future<bool> addToCart(Product product, {int quantity = 1}) async {
    try {
      final existingIndex =
          _items.indexWhere((item) => item.productId == product.id);

      if (existingIndex != -1) {
        // Update existing item
        final existingItem = _items[existingIndex];
        final newQuantity = existingItem.quantity + quantity;

        if (newQuantity > product.stockQuantity) {
          return false; // Not enough stock
        }

        _items[existingIndex] = existingItem.copyWith(quantity: newQuantity);
      } else {
        // Add new item
        if (quantity > product.stockQuantity) {
          return false; // Not enough stock
        }

        final cartItem = CartItem(
          productId: product.id,
          productName: product.nameEn,
          productNameAr: product.nameAr,
          price: product.price,
          quantity: quantity,
          unit: product.unit,
          category: product.category,
          supplierId: product.supplierId,
          supplierName: 'Supplier', // TODO: Get actual supplier name
          imageUrl: product.imageUrl,
          maxStock: product.stockQuantity,
        );

        _items.add(cartItem);
      }

      await _saveCart();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromCart(String productId) async {
    try {
      _items.removeWhere((item) => item.productId == productId);
      await _saveCart();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateQuantity(String productId, int quantity) async {
    try {
      if (quantity <= 0) {
        return await removeFromCart(productId);
      }

      final index = _items.indexWhere((item) => item.productId == productId);
      if (index != -1) {
        final item = _items[index];
        if (quantity > item.maxStock) {
          return false; // Not enough stock
        }

        _items[index] = item.copyWith(quantity: quantity);
        await _saveCart();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _saveCart();
    notifyListeners();
  }

  CartItem? getItem(String productId) {
    try {
      return _items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  bool hasItem(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  int getItemQuantity(String productId) {
    final item = getItem(productId);
    return item?.quantity ?? 0;
  }

  // Get cart summary for checkout
  Map<String, dynamic> getCartSummary() {
    return {
      'items': _items.map((item) => item.toJson()).toList(),
      'itemCount': itemCount,
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'supplierCount': itemsBySupplier.length,
    };
  }

  // Validate cart before checkout
  List<String> validateCart() {
    final List<String> errors = [];

    if (_items.isEmpty) {
      errors.add('Cart is empty');
    }

    for (final item in _items) {
      if (item.quantity > item.maxStock) {
        errors.add(
            '${item.productName}: Not enough stock (${item.maxStock} available)');
      }
      if (item.quantity <= 0) {
        errors.add('${item.productName}: Invalid quantity');
      }
    }

    return errors;
  }

  // Apply discount (for future use)
  double calculateDiscount(String? couponCode) {
    // TODO: Implement coupon system
    return 0.0;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
