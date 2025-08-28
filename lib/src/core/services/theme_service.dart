import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  ThemeService();

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }

  // Construction-themed colors
  static const Color primaryColor = Color(0xFF2E7D32); // Construction Green
  static const Color secondaryColor = Color(0xFF8D6E63); // Brown/Wood
  static const Color accentColor = Color(0xFFFF9800); // Orange/Safety
  static const Color steelBlue = Color(0xFF455A64); // Steel Blue
  static const Color cementGray = Color(0xFF9E9E9E); // Cement Gray
  static const Color brickRed = Color(0xFFD32F2F); // Brick Red
  static const Color successColor = Color(0xFF4CAF50); // Success Green
  static const Color warningColor = Color(0xFFFF9800); // Warning Orange
  static const Color errorColor = Color(0xFFD32F2F); // Error Red
  static const Color arabicGold = Color(0xFFFFD700); // Arabic Gold
}
