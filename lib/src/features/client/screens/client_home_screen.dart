import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/theme_service.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ClientHomeTab(),
    const ClientProductsTab(),
    const ClientCartTab(),
    const ClientOrdersTab(),
    const ClientProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: ThemeService.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: languageService.getLocalizedText('الرئيسية', 'Home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category_outlined),
            activeIcon: const Icon(Icons.category),
            label: languageService.getLocalizedText('المنتجات', 'Products'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            activeIcon: const Icon(Icons.shopping_cart),
            label: languageService.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long),
            label: languageService.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outlined),
            activeIcon: const Icon(Icons.person),
            label: languageService.profile,
          ),
        ],
      ),
    );
  }
}

class ClientHomeTab extends StatelessWidget {
  const ClientHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.appName),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement notifications
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ThemeService.primaryColor,
                    ThemeService.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageService.getLocalizedText(
                      'مرحباً بك في بنيان',
                      'Welcome to Bunyan',
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    languageService.getLocalizedText(
                      'سوق مواد البناء الأول في السعودية',
                      'Saudi Arabia\'s Premier Construction Marketplace',
                    ),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Categories Section
            Text(
              languageService.getLocalizedText('الفئات', 'Categories'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            // Categories Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildCategoryCard(
                  context: context,
                  title: languageService.cement,
                  icon: Icons.construction,
                  color: ThemeService.cementGray,
                ),
                _buildCategoryCard(
                  context: context,
                  title: languageService.steel,
                  icon: Icons.hardware,
                  color: ThemeService.steelBlue,
                ),
                _buildCategoryCard(
                  context: context,
                  title: languageService.bricks,
                  icon: Icons.view_module,
                  color: ThemeService.brickRed,
                ),
                _buildCategoryCard(
                  context: context,
                  title: languageService.tiles,
                  icon: Icons.grid_view,
                  color: ThemeService.primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Featured Products Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languageService.getLocalizedText(
                      'منتجات مميزة', 'Featured Products'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all products
                  },
                  child: Text(
                      languageService.getLocalizedText('عرض الكل', 'View All')),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Featured Products List
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.construction,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  languageService.getLocalizedText(
                                    'منتج ${index + 1}',
                                    'Product ${index + 1}',
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(index + 1) * 100} ${languageService.getLocalizedText('ريال', 'SAR')}',
                                  style: TextStyle(
                                    color: ThemeService.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category products
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder tabs
class ClientProductsTab extends StatelessWidget {
  const ClientProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('المنتجات', 'Products')),
      ),
      body: const Center(
        child: Text('Products Tab - Coming Soon'),
      ),
    );
  }
}

class ClientCartTab extends StatelessWidget {
  const ClientCartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context).cart),
      ),
      body: const Center(
        child: Text('Cart Tab - Coming Soon'),
      ),
    );
  }
}

class ClientOrdersTab extends StatelessWidget {
  const ClientOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context).orders),
      ),
      body: const Center(
        child: Text('Orders Tab - Coming Soon'),
      ),
    );
  }
}

class ClientProfileTab extends StatelessWidget {
  const ClientProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.profile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: ThemeService.primaryColor,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authService.user?.email ??
                              languageService.getLocalizedText(
                                  'مستخدم', 'User'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          languageService.customer,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              languageService.logout,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await authService.signOut();
              if (context.mounted) {
                // Navigation will be handled by the router's redirect logic
              }
            },
          ),
        ],
      ),
    );
  }
}
