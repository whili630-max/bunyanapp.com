import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/theme_service.dart';

class ConsoleHomeScreen extends StatefulWidget {
  const ConsoleHomeScreen({super.key});

  @override
  State<ConsoleHomeScreen> createState() => _ConsoleHomeScreenState();
}

class _ConsoleHomeScreenState extends State<ConsoleHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ConsoleDashboardTab(),
    const ConsoleUsersTab(),
    const ConsoleProductsTab(),
    const ConsoleOrdersTab(),
    const ConsoleSettingsTab(),
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
        selectedItemColor: ThemeService.steelBlue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: languageService.getLocalizedText('لوحة التحكم', 'Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outlined),
            activeIcon: const Icon(Icons.people),
            label: languageService.getLocalizedText('المستخدمين', 'Users'),
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
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: languageService.settings,
          ),
        ],
      ),
    );
  }
}

class ConsoleDashboardTab extends StatelessWidget {
  const ConsoleDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.getLocalizedText(
            'لوحة تحكم الإدارة', 'Admin Console')),
        backgroundColor: ThemeService.steelBlue,
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
                    ThemeService.steelBlue,
                    ThemeService.steelBlue.withOpacity(0.8),
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
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        languageService.getLocalizedText(
                          'مرحباً بك في لوحة الإدارة',
                          'Welcome to Admin Console',
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
                      'إدارة وتحكم كامل في منصة بنيان',
                      'Complete management and control of Bunyan platform',
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

            // Platform Stats
            Text(
              languageService.getLocalizedText(
                  'إحصائيات المنصة', 'Platform Statistics'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildStatCard(
                  context: context,
                  title: languageService.getLocalizedText(
                      'إجمالي المستخدمين', 'Total Users'),
                  value: '1,247',
                  icon: Icons.people,
                  color: ThemeService.primaryColor,
                  subtitle: languageService.getLocalizedText('نشط', 'Active'),
                ),
                _buildStatCard(
                  context: context,
                  title:
                      languageService.getLocalizedText('الموردين', 'Suppliers'),
                  value: '156',
                  icon: Icons.store,
                  color: ThemeService.secondaryColor,
                  subtitle:
                      languageService.getLocalizedText('مُعتمد', 'Verified'),
                ),
                _buildStatCard(
                  context: context,
                  title:
                      languageService.getLocalizedText('المنتجات', 'Products'),
                  value: '3,421',
                  icon: Icons.inventory,
                  color: ThemeService.accentColor,
                  subtitle:
                      languageService.getLocalizedText('منشور', 'Published'),
                ),
                _buildStatCard(
                  context: context,
                  title: languageService.getLocalizedText(
                      'الطلبات اليوم', 'Orders Today'),
                  value: '89',
                  icon: Icons.receipt_long,
                  color: ThemeService.successColor,
                  subtitle:
                      languageService.getLocalizedText('مكتمل', 'Completed'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Activities
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languageService.getLocalizedText(
                      'الأنشطة الحديثة', 'Recent Activities'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all activities
                  },
                  child: Text(
                      languageService.getLocalizedText('عرض الكل', 'View All')),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Activities List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final activities = [
                  {
                    'icon': Icons.person_add,
                    'title': languageService.getLocalizedText(
                        'مستخدم جديد', 'New User'),
                    'subtitle': languageService.getLocalizedText(
                        'انضم للمنصة', 'Joined the platform'),
                    'time':
                        '5 ${languageService.getLocalizedText('دقائق', 'minutes')}',
                    'color': ThemeService.primaryColor,
                  },
                  {
                    'icon': Icons.store_mall_directory,
                    'title': languageService.getLocalizedText(
                        'مورد جديد', 'New Supplier'),
                    'subtitle': languageService.getLocalizedText(
                        'طلب اعتماد', 'Requested verification'),
                    'time':
                        '15 ${languageService.getLocalizedText('دقيقة', 'minutes')}',
                    'color': ThemeService.secondaryColor,
                  },
                  {
                    'icon': Icons.add_box,
                    'title': languageService.getLocalizedText(
                        'منتج جديد', 'New Product'),
                    'subtitle': languageService.getLocalizedText(
                        'تم إضافته للمراجعة', 'Added for review'),
                    'time':
                        '30 ${languageService.getLocalizedText('دقيقة', 'minutes')}',
                    'color': ThemeService.accentColor,
                  },
                  {
                    'icon': Icons.shopping_cart,
                    'title': languageService.getLocalizedText(
                        'طلب جديد', 'New Order'),
                    'subtitle': languageService.getLocalizedText(
                        'تم تأكيده', 'Confirmed'),
                    'time':
                        '1 ${languageService.getLocalizedText('ساعة', 'hour')}',
                    'color': ThemeService.successColor,
                  },
                  {
                    'icon': Icons.report_problem,
                    'title': languageService.getLocalizedText(
                        'بلاغ جديد', 'New Report'),
                    'subtitle': languageService.getLocalizedText(
                        'يحتاج مراجعة', 'Needs review'),
                    'time':
                        '2 ${languageService.getLocalizedText('ساعة', 'hours')}',
                    'color': ThemeService.warningColor,
                  },
                ];

                final activity = activities[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          (activity['color'] as Color).withOpacity(0.1),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: 20,
                      ),
                    ),
                    title: Text(activity['title'] as String),
                    subtitle: Text(activity['subtitle'] as String),
                    trailing: Text(
                      activity['time'] as String,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      // TODO: Navigate to activity details
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

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  context: context,
                  title: languageService.getLocalizedText(
                      'إدارة المستخدمين', 'Manage Users'),
                  icon: Icons.people,
                  color: ThemeService.primaryColor,
                  onTap: () {
                    // TODO: Navigate to users management
                  },
                ),
                _buildActionCard(
                  context: context,
                  title: languageService.getLocalizedText(
                      'مراجعة المنتجات', 'Review Products'),
                  icon: Icons.rate_review,
                  color: ThemeService.accentColor,
                  onTap: () {
                    // TODO: Navigate to product reviews
                  },
                ),
                _buildActionCard(
                  context: context,
                  title:
                      languageService.getLocalizedText('التقارير', 'Reports'),
                  icon: Icons.analytics,
                  color: ThemeService.successColor,
                  onTap: () {
                    // TODO: Navigate to reports
                  },
                ),
                _buildActionCard(
                  context: context,
                  title:
                      languageService.getLocalizedText('الإعدادات', 'Settings'),
                  icon: Icons.settings,
                  color: ThemeService.steelBlue,
                  onTap: () {
                    // TODO: Navigate to settings
                  },
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
    required String subtitle,
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder tabs
class ConsoleUsersTab extends StatelessWidget {
  const ConsoleUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('إدارة المستخدمين', 'User Management')),
        backgroundColor: ThemeService.steelBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Console Users Tab - Coming Soon'),
      ),
    );
  }
}

class ConsoleProductsTab extends StatelessWidget {
  const ConsoleProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('إدارة المنتجات', 'Product Management')),
        backgroundColor: ThemeService.steelBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Console Products Tab - Coming Soon'),
      ),
    );
  }
}

class ConsoleOrdersTab extends StatelessWidget {
  const ConsoleOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('إدارة الطلبات', 'Order Management')),
        backgroundColor: ThemeService.steelBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Console Orders Tab - Coming Soon'),
      ),
    );
  }
}

class ConsoleSettingsTab extends StatelessWidget {
  const ConsoleSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.settings),
        backgroundColor: ThemeService.steelBlue,
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
                    backgroundColor: ThemeService.steelBlue,
                    child: const Icon(
                      Icons.admin_panel_settings,
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
                              languageService.getLocalizedText('مدير', 'Admin'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          languageService.admin,
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
