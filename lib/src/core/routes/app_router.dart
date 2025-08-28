import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/client/screens/modern_client_home_screen.dart';
import '../../features/client/screens/client_cart_screen.dart';
import '../../features/client/screens/client_orders_screen.dart';
import '../../features/client/screens/client_profile_screen.dart';
import '../../features/client/screens/products_screen.dart';
import '../../features/supplier/screens/supplier_home_screen.dart';
import '../../features/console/screens/console_home_screen.dart';
import '../../features/driver/screens/driver_home_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../../main.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.user;
      final isLoggedIn = user != null;
      final location = state.matchedLocation;

      // Platform-specific redirects for authenticated users
      if (isLoggedIn) {
        if (location.startsWith('/client') &&
            !location.contains('/dashboard')) {
          return '/client/dashboard';
        }
        if (location.startsWith('/supplier') &&
            !location.contains('/dashboard')) {
          return '/supplier/dashboard';
        }
        if (location.startsWith('/driver') &&
            !location.contains('/dashboard')) {
          return '/driver/dashboard';
        }
        if (location.startsWith('/console') &&
            !location.contains('/dashboard')) {
          return '/console/dashboard';
        }
      }

      // Redirect unauthenticated users trying to access protected routes
      if (!isLoggedIn && _isProtectedRoute(location)) {
        if (location.startsWith('/client')) return '/client';
        if (location.startsWith('/supplier')) return '/supplier';
        if (location.startsWith('/driver')) return '/driver';
        if (location.startsWith('/console')) return '/console';
        return '/splash';
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // CLIENT PLATFORM - منصة العملاء
      GoRoute(
        path: '/client',
        name: 'client-landing',
        builder: (context, state) => const ClientLandingPage(),
      ),
      GoRoute(
        path: '/client/login',
        name: 'client-login',
        builder: (context, state) => const LoginScreen(userType: 'client'),
      ),
      GoRoute(
        path: '/client/register',
        name: 'client-register',
        builder: (context, state) => const RegisterScreen(userType: 'client'),
      ),
      GoRoute(
        path: '/client/dashboard',
        name: 'client-dashboard',
        builder: (context, state) => const ModernClientHomeScreen(),
        routes: [
          GoRoute(
            path: '/products',
            name: 'client-products',
            builder: (context, state) => const ClientProductsScreen(),
          ),
          GoRoute(
            path: '/cart',
            name: 'client-cart',
            builder: (context, state) => const ClientCartScreen(),
          ),
          GoRoute(
            path: '/orders',
            name: 'client-orders',
            builder: (context, state) => const ClientOrdersScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'client-profile',
            builder: (context, state) => const ClientProfileScreen(),
          ),
        ],
      ),

      // SUPPLIER PLATFORM - منصة الموردين
      GoRoute(
        path: '/supplier',
        name: 'supplier-landing',
        builder: (context, state) => const SupplierLandingPage(),
      ),
      GoRoute(
        path: '/supplier/login',
        name: 'supplier-login',
        builder: (context, state) => const LoginScreen(userType: 'supplier'),
      ),
      GoRoute(
        path: '/supplier/register',
        name: 'supplier-register',
        builder: (context, state) => const RegisterScreen(userType: 'supplier'),
      ),
      GoRoute(
        path: '/supplier/dashboard',
        name: 'supplier-dashboard',
        builder: (context, state) => const SupplierHomeScreen(),
        routes: [
          GoRoute(
            path: '/products',
            name: 'supplier-products',
            builder: (context, state) => const SupplierProductsScreen(),
          ),
          GoRoute(
            path: '/orders',
            name: 'supplier-orders',
            builder: (context, state) => const SupplierOrdersScreen(),
          ),
          GoRoute(
            path: '/analytics',
            name: 'supplier-analytics',
            builder: (context, state) => const SupplierAnalyticsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'supplier-profile',
            builder: (context, state) => const SupplierProfileScreen(),
          ),
        ],
      ),

      // DRIVER PLATFORM - منصة السائقين
      GoRoute(
        path: '/driver',
        name: 'driver-landing',
        builder: (context, state) => const DriverLandingPage(),
      ),
      GoRoute(
        path: '/driver/login',
        name: 'driver-login',
        builder: (context, state) => const LoginScreen(userType: 'driver'),
      ),
      GoRoute(
        path: '/driver/register',
        name: 'driver-register',
        builder: (context, state) => const RegisterScreen(userType: 'driver'),
      ),
      GoRoute(
        path: '/driver/dashboard',
        name: 'driver-dashboard',
        builder: (context, state) => const DriverHomeScreen(),
        routes: [
          GoRoute(
            path: '/deliveries',
            name: 'driver-deliveries',
            builder: (context, state) => const DriverDeliveriesScreen(),
          ),
          GoRoute(
            path: '/earnings',
            name: 'driver-earnings',
            builder: (context, state) => const DriverEarningsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'driver-profile',
            builder: (context, state) => const DriverProfileScreen(),
          ),
        ],
      ),

      // CONSOLE PLATFORM - لوحة التحكم (Admin Only)
      GoRoute(
        path: '/console',
        name: 'console-landing',
        builder: (context, state) => const ConsoleLandingPage(),
      ),
      GoRoute(
        path: '/console/login',
        name: 'console-login',
        builder: (context, state) => const LoginScreen(userType: 'admin'),
      ),
      GoRoute(
        path: '/console/dashboard',
        name: 'console-dashboard',
        builder: (context, state) => const ConsoleHomeScreen(),
        routes: [
          GoRoute(
            path: '/users',
            name: 'console-users',
            builder: (context, state) => const ConsoleUsersScreen(),
          ),
          GoRoute(
            path: '/products',
            name: 'console-products',
            builder: (context, state) => const ConsoleProductsScreen(),
          ),
          GoRoute(
            path: '/orders',
            name: 'console-orders',
            builder: (context, state) => const ConsoleOrdersScreen(),
          ),
          GoRoute(
            path: '/analytics',
            name: 'console-analytics',
            builder: (context, state) => const ConsoleAnalyticsScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'console-settings',
            builder: (context, state) => const ConsoleSettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'صفحة غير موجودة',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/splash'),
              child: const Text('العودة للرئيسية / Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  // Helper methods
  static bool _isProtectedRoute(String location) {
    final protectedRoutes = [
      '/client/dashboard',
      '/supplier/dashboard',
      '/driver/dashboard',
      '/console/dashboard',
    ];
    return protectedRoutes.any((route) => location.startsWith(route));
  }
}

// Placeholder screens - these will be created in their respective feature folders
class ClientProductsScreen extends StatelessWidget {
  const ClientProductsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const ProductsScreen(currentUserId: 'client_1');
}

class SupplierProductsScreen extends StatelessWidget {
  const SupplierProductsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Supplier Products')));
}

class SupplierOrdersScreen extends StatelessWidget {
  const SupplierOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Supplier Orders')));
}

class SupplierAnalyticsScreen extends StatelessWidget {
  const SupplierAnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Supplier Analytics')));
}

class SupplierProfileScreen extends StatelessWidget {
  const SupplierProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Supplier Profile')));
}

class ConsoleUsersScreen extends StatelessWidget {
  const ConsoleUsersScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Console Users')));
}

class ConsoleProductsScreen extends StatelessWidget {
  const ConsoleProductsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Console Products')));
}

class ConsoleOrdersScreen extends StatelessWidget {
  const ConsoleOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Console Orders')));
}

class ConsoleAnalyticsScreen extends StatelessWidget {
  const ConsoleAnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Console Analytics')));
}

class ConsoleSettingsScreen extends StatelessWidget {
  const ConsoleSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Console Settings')));
}

class DriverDeliveriesScreen extends StatelessWidget {
  const DriverDeliveriesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Driver Deliveries')));
}

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Driver Earnings')));
}

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Driver Profile')));
}
