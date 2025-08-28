import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'src/core/routes/app_router.dart';
import 'src/core/services/auth_service.dart';
import 'src/core/services/language_service.dart';
import 'src/core/services/theme_service.dart';
import 'src/core/services/cart_service.dart';
import 'src/core/database/database_service.dart';
import 'src/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database service
  await DatabaseService.instance.initialize();

  runApp(const BunyanApp());
}

class BunyanApp extends StatelessWidget {
  const BunyanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer2<ThemeService, LanguageService>(
        builder: (context, themeService, languageService, child) {
          return MaterialApp.router(
            title: 'Bunyan Marketplace',
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            locale: languageService.currentLocale,
            supportedLocales: const [
              Locale('ar', 'SA'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}

// Platform Landing Pages - Each with unique URL
class ClientLandingPage extends StatelessWidget {
  const ClientLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Client Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                languageService.getLocalizedText(
                    'منصة العملاء', 'Client Platform'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                languageService.getLocalizedText(
                    'تسوق مواد البناء من موردين معتمدين',
                    'Shop construction materials from verified suppliers'),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/client/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageService.login,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/client/register'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageService.register,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupplierLandingPage extends StatelessWidget {
  const SupplierLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF8D6E63),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Supplier Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.store,
                  size: 60,
                  color: Color(0xFF8D6E63),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                languageService.getLocalizedText(
                    'منصة الموردين', 'Supplier Platform'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                languageService.getLocalizedText('إدارة منتجاتك وطلباتك بسهولة',
                    'Manage your products and orders easily'),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/supplier/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF8D6E63),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageService.login,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/supplier/register'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageService.register,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverLandingPage extends StatelessWidget {
  const DriverLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFF9800),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Driver Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_shipping,
                  size: 60,
                  color: Color(0xFFFF9800),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                languageService.getLocalizedText(
                    'منصة السائقين', 'Driver Platform'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                languageService.getLocalizedText(
                    'إدارة عمليات التوصيل وتتبع الأرباح',
                    'Manage deliveries and track earnings'),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/driver/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF9800),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageService.login,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/driver/register'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageService.register,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConsoleLandingPage extends StatelessWidget {
  const ConsoleLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF455A64),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Console Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  size: 60,
                  color: Color(0xFF455A64),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                languageService.getLocalizedText(
                    'لوحة التحكم', 'Admin Console'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                languageService.getLocalizedText(
                    'إدارة النظام والمستخدمين والتقارير',
                    'Manage system, users and reports'),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/console/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF455A64),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    languageService.login,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlatformSelectionScreen extends StatelessWidget {
  const PlatformSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and Title
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.construction,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'بنيان',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const Text(
                'Bunyan Marketplace',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Saudi Construction Services Marketplace',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Platform Selection
              const Text(
                'اختر منصتك / Choose Your Platform',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Platform Cards
              _buildPlatformCard(
                context,
                'عميل / Client',
                'تسوق مواد البناء',
                'Shop Construction Materials',
                Icons.shopping_cart,
                const Color(0xFF2E7D32),
                () => _navigateToPlatform(context, 'Client'),
              ),
              const SizedBox(height: 16),
              _buildPlatformCard(
                context,
                'مورد / Supplier',
                'إدارة المنتجات والطلبات',
                'Manage Products & Orders',
                Icons.store,
                const Color(0xFF8D6E63),
                () => _navigateToPlatform(context, 'Supplier'),
              ),
              const SizedBox(height: 16),
              _buildPlatformCard(
                context,
                'لوحة التحكم / Console',
                'إدارة النظام',
                'System Administration',
                Icons.admin_panel_settings,
                const Color(0xFF455A64),
                () => _navigateToPlatform(context, 'Console'),
              ),
              const SizedBox(height: 16),
              _buildPlatformCard(
                context,
                'سائق / Driver',
                'إدارة التوصيل',
                'Delivery Management',
                Icons.local_shipping,
                const Color(0xFFFF9800),
                () => _navigateToPlatform(context, 'Driver'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformCard(
    BuildContext context,
    String title,
    String subtitleAr,
    String subtitleEn,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitleAr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      subtitleEn,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPlatform(BuildContext context, String platform) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlatformDemoScreen(platform: platform),
      ),
    );
  }
}

class PlatformDemoScreen extends StatelessWidget {
  final String platform;

  const PlatformDemoScreen({super.key, required this.platform});

  @override
  Widget build(BuildContext context) {
    final colors = _getPlatformColors();

    return Scaffold(
      appBar: AppBar(
        title: Text('$platform Platform'),
        backgroundColor: colors['primary'],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors['primary']?.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors['primary']!.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    _getPlatformIcon(),
                    size: 64,
                    color: colors['primary'],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$platform Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors['primary'],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getPlatformDescription(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors['primary'],
              ),
            ),
            const SizedBox(height: 16),
            ..._getPlatformFeatures().map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: colors['primary'],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('$platform platform is ready for development!'),
                      backgroundColor: colors['primary'],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors['primary'],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Color> _getPlatformColors() {
    switch (platform) {
      case 'Client':
        return {'primary': const Color(0xFF2E7D32)};
      case 'Supplier':
        return {'primary': const Color(0xFF8D6E63)};
      case 'Console':
        return {'primary': const Color(0xFF455A64)};
      case 'Driver':
        return {'primary': const Color(0xFFFF9800)};
      default:
        return {'primary': const Color(0xFF2E7D32)};
    }
  }

  IconData _getPlatformIcon() {
    switch (platform) {
      case 'Client':
        return Icons.shopping_cart;
      case 'Supplier':
        return Icons.store;
      case 'Console':
        return Icons.admin_panel_settings;
      case 'Driver':
        return Icons.local_shipping;
      default:
        return Icons.construction;
    }
  }

  String _getPlatformDescription() {
    switch (platform) {
      case 'Client':
        return 'Browse and purchase construction materials from verified suppliers across Saudi Arabia.';
      case 'Supplier':
        return 'Manage your construction materials inventory, process orders, and grow your business.';
      case 'Console':
        return 'Administrative dashboard to manage users, products, orders, and platform analytics.';
      case 'Driver':
        return 'Manage deliveries, track earnings, and provide reliable delivery services.';
      default:
        return 'Construction marketplace platform';
    }
  }

  List<String> _getPlatformFeatures() {
    switch (platform) {
      case 'Client':
        return [
          'Browse construction materials by category',
          'Search and filter products',
          'Add items to cart and checkout',
          'Track order status and delivery',
          'Rate and review suppliers',
          'Manage delivery addresses',
        ];
      case 'Supplier':
        return [
          'Add and manage product catalog',
          'Process incoming orders',
          'Track inventory levels',
          'View sales analytics',
          'Communicate with customers',
          'Manage business profile',
        ];
      case 'Console':
        return [
          'User management and verification',
          'Product moderation and approval',
          'Order monitoring and oversight',
          'Platform analytics and reports',
          'System configuration',
          'Support ticket management',
        ];
      case 'Driver':
        return [
          'View available delivery requests',
          'Accept and manage deliveries',
          'Navigate to pickup/delivery locations',
          'Update delivery status',
          'Track earnings and payments',
          'Rate customers and suppliers',
        ];
      default:
        return [];
    }
  }
}
