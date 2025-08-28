import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/theme_service.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DriverDashboardTab(),
    const DriverDeliveriesTab(),
    const DriverEarningsTab(),
    const DriverProfileTab(),
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
        selectedItemColor: ThemeService.accentColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: languageService.getLocalizedText('لوحة التحكم', 'Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping_outlined),
            activeIcon: const Icon(Icons.local_shipping),
            label: languageService.getLocalizedText('التوصيلات', 'Deliveries'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: languageService.getLocalizedText('الأرباح', 'Earnings'),
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

class DriverDashboardTab extends StatelessWidget {
  const DriverDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.getLocalizedText(
            'لوحة تحكم السائق', 'Driver Dashboard')),
        backgroundColor: ThemeService.accentColor,
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
                    ThemeService.accentColor,
                    ThemeService.accentColor.withOpacity(0.8),
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
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        languageService.getLocalizedText(
                          'مرحباً بك في منصة السائقين',
                          'Welcome to Driver Platform',
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
                      'ابدأ رحلتك في التوصيل اليوم',
                      'Start your delivery journey today',
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

            // Status Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      languageService.getLocalizedText(
                          'متاح للتوصيل', 'Available for Delivery'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Toggle availability
                      },
                      activeColor: ThemeService.successColor,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Today's Stats
            Text(
              languageService.getLocalizedText(
                  'إحصائيات اليوم', 'Today\'s Stats'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title: languageService.getLocalizedText(
                        'التوصيلات', 'Deliveries'),
                    value: '8',
                    icon: Icons.local_shipping,
                    color: ThemeService.accentColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title:
                        languageService.getLocalizedText('الأرباح', 'Earnings'),
                    value:
                        '320 ${languageService.getLocalizedText('ريال', 'SAR')}',
                    icon: Icons.account_balance_wallet,
                    color: ThemeService.successColor,
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
                        languageService.getLocalizedText('المسافة', 'Distance'),
                    value:
                        '124 ${languageService.getLocalizedText('كم', 'KM')}',
                    icon: Icons.route,
                    color: ThemeService.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title:
                        languageService.getLocalizedText('التقييم', 'Rating'),
                    value: '4.9',
                    icon: Icons.star,
                    color: ThemeService.arabicGold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Available Deliveries
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  languageService.getLocalizedText(
                      'التوصيلات المتاحة', 'Available Deliveries'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all deliveries
                  },
                  child: Text(
                      languageService.getLocalizedText('عرض الكل', 'View All')),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Deliveries List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    ThemeService.accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.local_shipping,
                                color: ThemeService.accentColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    languageService.getLocalizedText(
                                      'طلب #${1000 + index}',
                                      'Order #${1000 + index}',
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${(index + 1) * 5} ${languageService.getLocalizedText('كم', 'KM')} • ${(index + 1) * 25} ${languageService.getLocalizedText('ريال', 'SAR')}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    ThemeService.successColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                languageService.getLocalizedText(
                                    'متاح', 'Available'),
                                style: TextStyle(
                                  color: ThemeService.successColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                languageService.getLocalizedText(
                                  'من: الرياض - إلى: جدة',
                                  'From: Riyadh - To: Jeddah',
                                ),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // TODO: View delivery details
                                },
                                child: Text(languageService.getLocalizedText(
                                    'التفاصيل', 'Details')),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Accept delivery
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeService.accentColor,
                                ),
                                child: Text(
                                  languageService.getLocalizedText(
                                      'قبول', 'Accept'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                    fontSize: 16,
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
}

// Placeholder tabs
class DriverDeliveriesTab extends StatelessWidget {
  const DriverDeliveriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('توصيلاتي', 'My Deliveries')),
        backgroundColor: ThemeService.accentColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Driver Deliveries Tab - Coming Soon'),
      ),
    );
  }
}

class DriverEarningsTab extends StatelessWidget {
  const DriverEarningsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('أرباحي', 'My Earnings')),
        backgroundColor: ThemeService.accentColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Driver Earnings Tab - Coming Soon'),
      ),
    );
  }
}

class DriverProfileTab extends StatelessWidget {
  const DriverProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.profile),
        backgroundColor: ThemeService.accentColor,
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
                    backgroundColor: ThemeService.accentColor,
                    child: const Icon(
                      Icons.local_shipping,
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
                                  'سائق', 'Driver'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          languageService.driver,
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

          // Driver Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageService.getLocalizedText(
                        'إحصائياتي', 'My Statistics'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '156',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ThemeService.accentColor,
                            ),
                          ),
                          Text(
                            languageService.getLocalizedText(
                                'توصيلة', 'Deliveries'),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '4.9',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ThemeService.arabicGold,
                            ),
                          ),
                          Text(
                            languageService.getLocalizedText(
                                'التقييم', 'Rating'),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '2,340',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ThemeService.successColor,
                            ),
                          ),
                          Text(
                            languageService.getLocalizedText('كم', 'KM'),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
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
