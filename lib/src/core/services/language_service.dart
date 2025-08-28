import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  Locale _locale = const Locale('ar', 'SA'); // Default to Arabic
  Locale get locale => _locale;
  Locale get currentLocale => _locale;

  bool get isArabic => _locale.languageCode == 'ar';
  bool get isEnglish => _locale.languageCode == 'en';

  LanguageService();

  Future<void> setLanguage(String languageCode) async {
    if (languageCode == 'en') {
      _locale = const Locale('en', 'US');
    } else {
      _locale = const Locale('ar', 'SA');
    }

    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    final newLanguage = isArabic ? 'en' : 'ar';
    await setLanguage(newLanguage);
  }

  String getLocalizedText(String arabicText, String englishText) {
    return isArabic ? arabicText : englishText;
  }

  // Common translations
  String get appName => getLocalizedText('بنيان', 'Bunyan');
  String get welcome => getLocalizedText('مرحباً', 'Welcome');
  String get login => getLocalizedText('تسجيل الدخول', 'Login');
  String get register => getLocalizedText('إنشاء حساب', 'Register');
  String get email => getLocalizedText('البريد الإلكتروني', 'Email');
  String get password => getLocalizedText('كلمة المرور', 'Password');
  String get confirmPassword =>
      getLocalizedText('تأكيد كلمة المرور', 'Confirm Password');
  String get name => getLocalizedText('الاسم', 'Name');
  String get phone => getLocalizedText('رقم الهاتف', 'Phone Number');
  String get address => getLocalizedText('العنوان', 'Address');
  String get save => getLocalizedText('حفظ', 'Save');
  String get cancel => getLocalizedText('إلغاء', 'Cancel');
  String get delete => getLocalizedText('حذف', 'Delete');
  String get edit => getLocalizedText('تعديل', 'Edit');
  String get search => getLocalizedText('بحث', 'Search');
  String get filter => getLocalizedText('تصفية', 'Filter');
  String get sort => getLocalizedText('ترتيب', 'Sort');
  String get price => getLocalizedText('السعر', 'Price');
  String get quantity => getLocalizedText('الكمية', 'Quantity');
  String get total => getLocalizedText('المجموع', 'Total');
  String get cart => getLocalizedText('السلة', 'Cart');
  String get checkout => getLocalizedText('الدفع', 'Checkout');
  String get orders => getLocalizedText('الطلبات', 'Orders');
  String get profile => getLocalizedText('الملف الشخصي', 'Profile');
  String get settings => getLocalizedText('الإعدادات', 'Settings');
  String get logout => getLocalizedText('تسجيل الخروج', 'Logout');
  String get loading => getLocalizedText('جاري التحميل...', 'Loading...');
  String get error => getLocalizedText('خطأ', 'Error');
  String get success => getLocalizedText('نجح', 'Success');
  String get retry => getLocalizedText('إعادة المحاولة', 'Retry');
  String get noData => getLocalizedText('لا توجد بيانات', 'No Data');
  String get noInternet =>
      getLocalizedText('لا يوجد اتصال بالإنترنت', 'No Internet Connection');

  // User types
  String get customer => getLocalizedText('عميل', 'Customer');
  String get supplier => getLocalizedText('مورد', 'Supplier');
  String get driver => getLocalizedText('سائق', 'Driver');
  String get admin => getLocalizedText('مدير', 'Admin');

  // Order statuses
  String get pending => getLocalizedText('في الانتظار', 'Pending');
  String get confirmed => getLocalizedText('مؤكد', 'Confirmed');
  String get processing => getLocalizedText('قيد المعالجة', 'Processing');
  String get shipped => getLocalizedText('تم الشحن', 'Shipped');
  String get delivered => getLocalizedText('تم التسليم', 'Delivered');
  String get cancelled => getLocalizedText('ملغي', 'Cancelled');

  // Product categories (Construction related)
  String get cement => getLocalizedText('أسمنت', 'Cement');
  String get steel => getLocalizedText('حديد', 'Steel');
  String get bricks => getLocalizedText('طوب', 'Bricks');
  String get tiles => getLocalizedText('بلاط', 'Tiles');
  String get paint => getLocalizedText('دهان', 'Paint');
  String get tools => getLocalizedText('أدوات', 'Tools');
  String get electrical => getLocalizedText('كهربائيات', 'Electrical');
  String get plumbing => getLocalizedText('سباكة', 'Plumbing');
  String get insulation => getLocalizedText('عزل', 'Insulation');
  String get flooring => getLocalizedText('أرضيات', 'Flooring');
}
