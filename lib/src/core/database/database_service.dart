import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/chat_message.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();
  DatabaseService._();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _initializeDefaultData();
  }

  // User Management
  Future<bool> createUser(User user) async {
    try {
      final users = await getAllUsers();

      // Check if user already exists
      if (users.any((u) => u.email == user.email)) {
        return false;
      }

      users.add(user);
      await _saveUsers(users);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> authenticateUser(String email, String password) async {
    try {
      final users = await getAllUsers();
      return users.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('User not found'),
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    final usersJson = _prefs?.getStringList('users') ?? [];
    return usersJson.map((json) => User.fromJson(jsonDecode(json))).toList();
  }

  Future<void> _saveUsers(List<User> users) async {
    final usersJson = users.map((user) => jsonEncode(user.toJson())).toList();
    await _prefs?.setStringList('users', usersJson);
  }

  // Product Management
  Future<List<Product>> getProducts(
      {String? category, String? supplierId}) async {
    final productsJson = _prefs?.getStringList('products') ?? [];
    var products =
        productsJson.map((json) => Product.fromJson(jsonDecode(json))).toList();

    if (category != null) {
      products = products.where((p) => p.category == category).toList();
    }

    if (supplierId != null) {
      products = products.where((p) => p.supplierId == supplierId).toList();
    }

    return products;
  }

  Future<bool> addProduct(Product product) async {
    try {
      final products = await getProducts();
      products.add(product);
      await _saveProducts(products);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      final products = await getProducts();
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
        await _saveProducts(products);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveProducts(List<Product> products) async {
    final productsJson =
        products.map((product) => jsonEncode(product.toJson())).toList();
    await _prefs?.setStringList('products', productsJson);
  }

  // Order Management
  Future<List<Order>> getOrders(
      {String? userId, String? supplierId, OrderStatus? status}) async {
    final ordersJson = _prefs?.getStringList('orders') ?? [];
    var orders =
        ordersJson.map((json) => Order.fromJson(jsonDecode(json))).toList();

    if (userId != null) {
      orders = orders.where((o) => o.customerId == userId).toList();
    }

    if (supplierId != null) {
      orders = orders.where((o) => o.supplierId == supplierId).toList();
    }

    if (status != null) {
      orders = orders.where((o) => o.status == status).toList();
    }

    return orders;
  }

  Future<bool> createOrder(Order order) async {
    try {
      final orders = await getOrders();
      orders.add(order);
      await _saveOrders(orders);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final orders = await getOrders();
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: status);
        await _saveOrders(orders);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveOrders(List<Order> orders) async {
    final ordersJson =
        orders.map((order) => jsonEncode(order.toJson())).toList();
    await _prefs?.setStringList('orders', ordersJson);
  }

  // Chat System
  Future<List<ChatMessage>> getChatMessages(String chatId) async {
    final messagesJson = _prefs?.getStringList('chat_$chatId') ?? [];
    return messagesJson
        .map((json) => ChatMessage.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<bool> sendMessage(String chatId, ChatMessage message) async {
    try {
      final messages = await getChatMessages(chatId);
      messages.add(message);
      await _saveChatMessages(chatId, messages);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveChatMessages(
      String chatId, List<ChatMessage> messages) async {
    final messagesJson =
        messages.map((msg) => jsonEncode(msg.toJson())).toList();
    await _prefs?.setStringList('chat_$chatId', messagesJson);
  }

  Future<List<String>> getUserChats(String userId) async {
    final chats = _prefs?.getStringList('user_chats_$userId') ?? [];
    return chats;
  }

  Future<void> addUserToChat(String userId, String chatId) async {
    final chats = await getUserChats(userId);
    if (!chats.contains(chatId)) {
      chats.add(chatId);
      await _prefs?.setStringList('user_chats_$userId', chats);
    }
  }

  // Initialize default data
  Future<void> _initializeDefaultData() async {
    final users = await getAllUsers();
    if (users.isEmpty) {
      // Create default users
      await createUser(User(
        id: 'admin_1',
        name: 'مدير النظام',
        email: 'admin@bunyan.sa',
        password: 'admin123',
        userType: UserType.admin,
        phone: '+966501234567',
        isVerified: true,
      ));

      await createUser(User(
        id: 'supplier_1',
        name: 'شركة مواد البناء المتقدمة',
        email: 'supplier@bunyan.sa',
        password: 'supplier123',
        userType: UserType.supplier,
        phone: '+966502345678',
        isVerified: true,
      ));

      await createUser(User(
        id: 'client_1',
        name: 'أحمد محمد العلي',
        email: 'client@bunyan.sa',
        password: 'client123',
        userType: UserType.client,
        phone: '+966503456789',
        isVerified: true,
      ));

      await createUser(User(
        id: 'driver_1',
        name: 'محمد سالم النقل',
        email: 'driver@bunyan.sa',
        password: 'driver123',
        userType: UserType.driver,
        phone: '+966504567890',
        isVerified: true,
      ));
    }

    final products = await getProducts();
    if (products.isEmpty) {
      // Create default products
      await addProduct(Product(
        id: 'prod_1',
        nameAr: 'أسمنت بورتلاندي عادي',
        nameEn: 'Ordinary Portland Cement',
        descriptionAr: 'أسمنت عالي الجودة مناسب لجميع أعمال البناء',
        descriptionEn:
            'High quality cement suitable for all construction works',
        price: 25.0,
        category: 'cement',
        supplierId: 'supplier_1',
        stockQuantity: 1000,
        unit: 'كيس 50 كيلو',
        imageUrl: 'assets/images/cement.jpg',
        isAvailable: true,
      ));

      await addProduct(Product(
        id: 'prod_2',
        nameAr: 'حديد تسليح 12 ملم',
        nameEn: '12mm Rebar Steel',
        descriptionAr: 'حديد تسليح عالي المقاومة للخرسانة المسلحة',
        descriptionEn: 'High strength rebar steel for reinforced concrete',
        price: 2800.0,
        category: 'steel',
        supplierId: 'supplier_1',
        stockQuantity: 500,
        unit: 'طن',
        imageUrl: 'assets/images/rebar.jpg',
        isAvailable: true,
      ));

      await addProduct(Product(
        id: 'prod_3',
        nameAr: 'طوب أحمر عادي',
        nameEn: 'Red Clay Bricks',
        descriptionAr: 'طوب أحمر طبيعي عالي الجودة للبناء',
        descriptionEn: 'High quality natural red clay bricks for construction',
        price: 0.75,
        category: 'bricks',
        supplierId: 'supplier_1',
        stockQuantity: 10000,
        unit: 'قطعة',
        imageUrl: 'assets/images/bricks.jpg',
        isAvailable: true,
      ));
    }
  }

  // Security & Configuration
  Future<void> logUserActivity(
      String userId, String action, Map<String, dynamic> details) async {
    final logs = _prefs?.getStringList('activity_logs') ?? [];
    final logEntry = {
      'userId': userId,
      'action': action,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    };
    logs.add(jsonEncode(logEntry));

    // Keep only last 1000 logs
    if (logs.length > 1000) {
      logs.removeRange(0, logs.length - 1000);
    }

    await _prefs?.setStringList('activity_logs', logs);
  }

  Future<List<Map<String, dynamic>>> getActivityLogs({String? userId}) async {
    final logs = _prefs?.getStringList('activity_logs') ?? [];
    var activities =
        logs.map((log) => jsonDecode(log) as Map<String, dynamic>).toList();

    if (userId != null) {
      activities = activities.where((log) => log['userId'] == userId).toList();
    }

    return activities.reversed.toList(); // Most recent first
  }

  // App Configuration
  Future<Map<String, dynamic>> getAppConfig() async {
    final configJson = _prefs?.getString('app_config');
    if (configJson != null) {
      return jsonDecode(configJson);
    }

    // Default configuration
    final defaultConfig = {
      'app_version': '1.0.0',
      'maintenance_mode': false,
      'max_order_amount': 100000.0,
      'delivery_fee': 50.0,
      'tax_rate': 0.15,
      'supported_languages': ['ar', 'en'],
      'chat_enabled': true,
      'notifications_enabled': true,
      'order_auto_confirm_hours': 24,
    };

    await updateAppConfig(defaultConfig);
    return defaultConfig;
  }

  Future<void> updateAppConfig(Map<String, dynamic> config) async {
    await _prefs?.setString('app_config', jsonEncode(config));
  }
}
