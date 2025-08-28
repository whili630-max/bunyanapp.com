import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/theme_service.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({super.key});

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SupplierDashboardTab(),
    const SupplierProductsTab(),
    const SupplierOrdersTab(),
    const SupplierAnalyticsTab(),
    const SupplierProfileTab(),
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
        selectedItemColor: ThemeService.secondaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: languageService.getLocalizedText('لوحة التحكم', 'Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory_outlined),
            activeIcon: const Icon(Icons.inventory),
            label: languageService.getLocalizedText('المنتجات', 'Products'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long),
            label: languageService.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_outlined),
            activeIcon: const Icon(Icons.analytics),
            label: languageService.getLocalizedText('التحليلات', 'Analytics'),
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

class SupplierDashboardTab extends StatelessWidget {
  const SupplierDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.getLocalizedText(
            'لوحة تحكم المورد', 'Supplier Dashboard')),
        backgroundColor: ThemeService.secondaryColor,
        foregroundColor: Colors.white,
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
                    ThemeService.secondaryColor,
                    ThemeService.secondaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.store,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        languageService.getLocalizedText(
                          'مرحباً بك في منصة الموردين',
                          'Welcome to Supplier Platform',
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    languageService.getLocalizedText(
                      'إدارة منتجاتك وطلباتك بسهولة',
                      'Manage your products and orders easily',
                    ),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title: languageService.getLocalizedText(
                        'المنتجات', 'Products'),
                    value: '24',
                    icon: Icons.inventory,
                    color: ThemeService.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title:
                        languageService.getLocalizedText('الطلبات', 'Orders'),
                    value: '12',
                    icon: Icons.receipt_long,
                    color: ThemeService.accentColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title:
                        languageService.getLocalizedText('المبيعات', 'Sales'),
                    value:
                        '15,420 ${languageService.getLocalizedText('ريال', 'SAR')}',
                    icon: Icons.trending_up,
                    color: ThemeService.successColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title:
                        languageService.getLocalizedText('التقييم', 'Rating'),
                    value: '4.8',
                    icon: Icons.star,
                    color: ThemeService.arabicGold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Orders Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languageService.getLocalizedText(
                      'الطلبات الحديثة', 'Recent Orders'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all orders
                  },
                  child: Text(
                      languageService.getLocalizedText('عرض الكل', 'View All')),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Orders List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          ThemeService.secondaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.receipt_long,
                        color: ThemeService.secondaryColor,
                      ),
                    ),
                    title: Text(
                      languageService.getLocalizedText(
                        'طلب #${1000 + index}',
                        'Order #${1000 + index}',
                      ),
                    ),
                    subtitle: Text(
                      '${(index + 1) * 500} ${languageService.getLocalizedText('ريال', 'SAR')}',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ThemeService.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        languageService.getLocalizedText('جديد', 'New'),
                        style: TextStyle(
                          color: ThemeService.successColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () {
                      // TODO: Navigate to order details
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              languageService.getLocalizedText(
                  'إجراءات سريعة', 'Quick Actions'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    title: languageService.getLocalizedText(
                        'إضافة منتج', 'Add Product'),
                    icon: Icons.add_box,
                    color: ThemeService.primaryColor,
                    onTap: () {
                      // TODO: Navigate to add product
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    title: languageService.getLocalizedText(
                        'إدارة المخزون', 'Manage Inventory'),
                    icon: Icons.inventory_2,
                    color: ThemeService.accentColor,
                    onTap: () {
                      // TODO: Navigate to inventory
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
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
class SupplierProductsTab extends StatelessWidget {
  const SupplierProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('منتجاتي', 'My Products')),
        backgroundColor: ThemeService.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Supplier Products Tab - Coming Soon'),
      ),
    );
  }
}

class SupplierOrdersTab extends StatelessWidget {
  const SupplierOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context).orders),
        backgroundColor: ThemeService.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Supplier Orders Tab - Coming Soon'),
      ),
    );
  }
}

class SupplierAnalyticsTab extends StatelessWidget {
  const SupplierAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('التحليلات', 'Analytics')),
        backgroundColor: ThemeService.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Supplier Analytics Tab - Coming Soon'),
      ),
    );
  }
}

class SupplierProfileTab extends StatelessWidget {
  const SupplierProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.profile),
        backgroundColor: ThemeService.secondaryColor,
        foregroundColor: Colors.white,
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
                    backgroundColor: ThemeService.secondaryColor,
                    child: const Icon(
                      Icons.store,
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
                                  'مورد', 'Supplier'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          languageService.supplier,
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
