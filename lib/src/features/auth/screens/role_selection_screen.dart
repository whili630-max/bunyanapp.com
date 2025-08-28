import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/theme_service.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                const SizedBox(height: 40),

                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.construction,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // App Name
                Text(
                  languageService.appName,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 10),

                // Subtitle
                Text(
                  languageService.getLocalizedText(
                    'اختر نوع حسابك للمتابعة',
                    'Choose your account type to continue',
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // Role Cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      _buildRoleCard(
                        context: context,
                        title: languageService.customer,
                        subtitle: languageService.getLocalizedText(
                          'تسوق مواد البناء',
                          'Shop construction materials',
                        ),
                        icon: Icons.shopping_cart,
                        color: ThemeService.primaryColor,
                        onTap: () => context.go('/login?type=customer'),
                      ),
                      _buildRoleCard(
                        context: context,
                        title: languageService.supplier,
                        subtitle: languageService.getLocalizedText(
                          'بيع المنتجات',
                          'Sell products',
                        ),
                        icon: Icons.store,
                        color: ThemeService.secondaryColor,
                        onTap: () => context.go('/login?type=supplier'),
                      ),
                      _buildRoleCard(
                        context: context,
                        title: languageService.driver,
                        subtitle: languageService.getLocalizedText(
                          'توصيل الطلبات',
                          'Deliver orders',
                        ),
                        icon: Icons.local_shipping,
                        color: ThemeService.accentColor,
                        onTap: () => context.go('/login?type=driver'),
                      ),
                      _buildRoleCard(
                        context: context,
                        title: languageService.admin,
                        subtitle: languageService.getLocalizedText(
                          'إدارة النظام',
                          'System management',
                        ),
                        icon: Icons.admin_panel_settings,
                        color: ThemeService.steelBlue,
                        onTap: () => context.go('/login?type=admin'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Language Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => languageService.toggleLanguage(),
                      icon: const Icon(Icons.language),
                      label: Text(
                        languageService.isArabic ? 'English' : 'العربية',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
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
