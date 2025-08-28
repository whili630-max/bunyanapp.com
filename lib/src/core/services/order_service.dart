import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/user.dart';
import '../database/database_service.dart';
import 'cart_service.dart';

class OrderService extends ChangeNotifier {
  static OrderService? _instance;
  static OrderService get instance => _instance ??= OrderService._();
  OrderService._();

  SharedPreferences? _prefs;
  List<Order> _orders = [];
  String? _currentUserId;

  List<Order> get orders => List.unmodifiable(_orders);
  List<Order> get userOrders =>
      _orders.where((order) => order.customerId == _currentUserId).toList();

  // Get orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders
        .where((order) =>
            order.status == status && order.customerId == _currentUserId)
        .toList();
  }

  // Get supplier orders
  List<Order> getSupplierOrders(String supplierId) {
    return _orders.where((order) => order.supplierId == supplierId).toList();
  }

  Future<void> initialize(String userId) async {
    _currentUserId = userId;
    _prefs = await SharedPreferences.getInstance();
    await _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (_currentUserId == null) return;

    final ordersJson = _prefs?.getStringList('orders') ?? [];
    _orders =
        ordersJson.map((json) => Order.fromJson(jsonDecode(json))).toList();

    // Sort by creation date (newest first)
    _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> _saveOrders() async {
    final ordersJson =
        _orders.map((order) => jsonEncode(order.toJson())).toList();
    await _prefs?.setStringList('orders', ordersJson);
  }

  Future<String?> createOrderFromCart({
    required String deliveryAddress,
    String? deliveryNotes,
  }) async {
    try {
      if (_currentUserId == null) return null;

      final cartService = CartService.instance;
      if (cartService.isEmpty) return null;

      // Get user information
      final users = await DatabaseService.instance.getAllUsers();
      final user = users.firstWhere((u) => u.id == _currentUserId);

      // Group cart items by supplier
      final itemsBySupplier = cartService.itemsBySupplier;
      final List<String> orderIds = [];

      // Create separate orders for each supplier
      for (final entry in itemsBySupplier.entries) {
        final supplierId = entry.key;
        final supplierItems = entry.value;

        // Get supplier information
        final supplier = users.firstWhere(
          (u) => u.id == supplierId,
          orElse: () => User(
            id: supplierId,
            name: 'Unknown Supplier',
            email: '',
            password: '',
            userType: UserType.supplier,
            phone: '',
          ),
        );

        // Calculate totals for this supplier
        final subtotal =
            supplierItems.fold(0.0, (sum, item) => sum + item.total);
        final taxAmount = subtotal * 0.15; // 15% VAT
        final deliveryFee = 50.0; // Fixed delivery fee per supplier
        final totalAmount = subtotal + taxAmount + deliveryFee;

        // Convert cart items to order items
        final orderItems = supplierItems
            .map((cartItem) => OrderItem(
                  productId: cartItem.productId,
                  productName: cartItem.productName,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                  unit: cartItem.unit,
                  total: cartItem.total,
                ))
            .toList();

        // Generate order ID
        final orderId =
            'order_${DateTime.now().millisecondsSinceEpoch}_${supplierId}';

        // Create order
        final order = Order(
          id: orderId,
          customerId: _currentUserId!,
          customerName: user.name,
          supplierId: supplierId,
          supplierName: supplier.name,
          items: orderItems,
          subtotal: subtotal,
          taxAmount: taxAmount,
          deliveryFee: deliveryFee,
          totalAmount: totalAmount,
          status: OrderStatus.pending,
          deliveryAddress: deliveryAddress,
          deliveryNotes: deliveryNotes,
          trackingNumber: _generateTrackingNumber(),
        );

        _orders.insert(0, order); // Add to beginning for newest first
        orderIds.add(orderId);

        // Log activity
        await DatabaseService.instance.logUserActivity(
          _currentUserId!,
          'order_created',
          {
            'orderId': orderId,
            'supplierId': supplierId,
            'totalAmount': totalAmount,
            'itemCount': orderItems.length,
          },
        );
      }

      // Save orders and clear cart
      await _saveOrders();
      await cartService.clearCart();
      notifyListeners();

      return orderIds.first; // Return first order ID
    } catch (e) {
      debugPrint('Error creating order: $e');
      return null;
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index == -1) return false;

      final updatedOrder = _orders[index].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        deliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : null,
      );

      _orders[index] = updatedOrder;
      await _saveOrders();
      notifyListeners();

      // Log activity
      if (_currentUserId != null) {
        await DatabaseService.instance.logUserActivity(
          _currentUserId!,
          'order_status_updated',
          {
            'orderId': orderId,
            'newStatus': newStatus.toString(),
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error updating order status: $e');
      return false;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final order = _orders.firstWhere((o) => o.id == orderId);

      // Check if order can be cancelled
      if (!order.canBeCancelled) return false;

      return await updateOrderStatus(orderId, OrderStatus.cancelled);
    } catch (e) {
      debugPrint('Error cancelling order: $e');
      return false;
    }
  }

  Order? getOrder(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get order statistics
  Map<String, dynamic> getOrderStatistics() {
    final userOrdersList = userOrders;

    return {
      'totalOrders': userOrdersList.length,
      'pendingOrders':
          userOrdersList.where((o) => o.status == OrderStatus.pending).length,
      'completedOrders':
          userOrdersList.where((o) => o.status == OrderStatus.delivered).length,
      'cancelledOrders':
          userOrdersList.where((o) => o.status == OrderStatus.cancelled).length,
      'totalSpent':
          userOrdersList.fold(0.0, (sum, order) => sum + order.totalAmount),
      'averageOrderValue': userOrdersList.isEmpty
          ? 0.0
          : userOrdersList.fold(0.0, (sum, order) => sum + order.totalAmount) /
              userOrdersList.length,
    };
  }

  // Get supplier statistics
  Map<String, dynamic> getSupplierStatistics(String supplierId) {
    final supplierOrdersList = getSupplierOrders(supplierId);

    return {
      'totalOrders': supplierOrdersList.length,
      'pendingOrders': supplierOrdersList
          .where((o) => o.status == OrderStatus.pending)
          .length,
      'processingOrders': supplierOrdersList
          .where((o) => o.status == OrderStatus.processing)
          .length,
      'completedOrders': supplierOrdersList
          .where((o) => o.status == OrderStatus.delivered)
          .length,
      'totalRevenue':
          supplierOrdersList.fold(0.0, (sum, order) => sum + order.totalAmount),
      'averageOrderValue': supplierOrdersList.isEmpty
          ? 0.0
          : supplierOrdersList.fold(
                  0.0, (sum, order) => sum + order.totalAmount) /
              supplierOrdersList.length,
    };
  }

  String _generateTrackingNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'BN$random';
  }

  // Search orders
  List<Order> searchOrders(String query) {
    if (query.isEmpty) return userOrders;

    final lowercaseQuery = query.toLowerCase();
    return userOrders.where((order) {
      return order.id.toLowerCase().contains(lowercaseQuery) ||
          order.trackingNumber?.toLowerCase().contains(lowercaseQuery) ==
              true ||
          order.supplierName.toLowerCase().contains(lowercaseQuery) ||
          order.items.any((item) =>
              item.productName.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Get recent orders (last 30 days)
  List<Order> getRecentOrders() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return userOrders
        .where((order) => order.createdAt.isAfter(thirtyDaysAgo))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
