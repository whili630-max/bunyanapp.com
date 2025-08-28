import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../database/database_service.dart';

class AuthService extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  final DatabaseService _databaseService = DatabaseService.instance;

  AuthService();

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Authenticate with database
      final user = await _databaseService.authenticateUser(email, password);

      if (user != null) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _error = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'حدث خطأ في تسجيل الدخول';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String userType,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Parse user type
      UserType type;
      switch (userType.toLowerCase()) {
        case 'client':
          type = UserType.client;
          break;
        case 'supplier':
          type = UserType.supplier;
          break;
        case 'driver':
          type = UserType.driver;
          break;
        case 'admin':
          type = UserType.admin;
          break;
        default:
          type = UserType.client;
      }

      // Create new user
      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        password: password,
        userType: type,
        phone: phone,
        isVerified: false,
      );

      // Save to database
      final success = await _databaseService.createUser(newUser);

      if (success) {
        _user = newUser;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _error = 'البريد الإلكتروني مستخدم بالفعل';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'حدث خطأ في إنشاء الحساب';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'حدث خطأ في إرسال رابط إعادة تعيين كلمة المرور';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get user home route based on user type
  String getUserHomeRoute() {
    if (_user == null) return '/role-selection';

    switch (_user!.userType) {
      case UserType.client:
        return '/client';
      case UserType.supplier:
        return '/supplier';
      case UserType.driver:
        return '/driver';
      case UserType.admin:
        return '/console';
    }
  }
}
