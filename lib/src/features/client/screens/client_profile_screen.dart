import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/language_service.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageService.getLocalizedText('الملف الشخصي', 'Profile'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF2E7D32),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    languageService.getLocalizedText(
                        'أحمد محمد العلي', 'Ahmed Mohammed Ali'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'client@bunyan.sa',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile Options
            _buildProfileOption(
              context,
              languageService,
              Icons.person_outline,
              languageService.getLocalizedText(
                  'معلومات الحساب', 'Account Information'),
              () => _showComingSoon(context, languageService),
            ),
            _buildProfileOption(
              context,
              languageService,
              Icons.location_on_outlined,
              languageService.getLocalizedText(
                  'عناوين التوصيل', 'Delivery Addresses'),
              () => _showComingSoon(context, languageService),
            ),
            _buildProfileOption(
              context,
              languageService,
              Icons.payment_outlined,
              languageService.getLocalizedText('طرق الدفع', 'Payment Methods'),
              () => _showComingSoon(context, languageService),
            ),
            _buildProfileOption(
              context,
              languageService,
              Icons.notifications_outlined,
              languageService.getLocalizedText('الإشعارات', 'Notifications'),
              () => _showComingSoon(context, languageService),
            ),
            _buildProfileOption(
              context,
              languageService,
              Icons.language_outlined,
              languageService.getLocalizedText('اللغة', 'Language'),
              () => _showComingSoon(context, languageService),
            ),
            _buildProfileOption(
              context,
              languageService,
              Icons.help_outline,
              languageService.getLocalizedText(
                  'المساعدة والدعم', 'Help & Support'),
              () => _showComingSoon(context, languageService),
            ),
            _buildProfileOption(
              context,
              languageService,
              Icons.info_outline,
              languageService.getLocalizedText('حول التطبيق', 'About App'),
              () => _showComingSoon(context, languageService),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context, languageService),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  languageService.getLocalizedText('تسجيل الخروج', 'Logout'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    LanguageService languageService,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF2E7D32),
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          languageService.getLocalizedText('قريباً', 'Coming Soon'),
        ),
        content: Text(
          languageService.getLocalizedText(
            'هذه الميزة ستكون متاحة قريباً',
            'This feature will be available soon',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              languageService.getLocalizedText('حسناً', 'OK'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(
      BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          languageService.getLocalizedText('تسجيل الخروج', 'Logout'),
        ),
        content: Text(
          languageService.getLocalizedText(
            'هل أنت متأكد من تسجيل الخروج؟',
            'Are you sure you want to logout?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              languageService.getLocalizedText('إلغاء', 'Cancel'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/client');
            },
            child: Text(
              languageService.getLocalizedText('تسجيل الخروج', 'Logout'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
