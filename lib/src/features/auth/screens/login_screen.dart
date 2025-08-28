import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/theme_service.dart';

class LoginScreen extends StatefulWidget {
  final String userType;

  const LoginScreen({
    super.key,
    required this.userType,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getUserTypeTitle(LanguageService languageService) {
    switch (widget.userType) {
      case 'customer':
        return languageService.customer;
      case 'supplier':
        return languageService.supplier;
      case 'driver':
        return languageService.driver;
      case 'admin':
        return languageService.admin;
      default:
        return languageService.customer;
    }
  }

  IconData _getUserTypeIcon() {
    switch (widget.userType) {
      case 'customer':
        return Icons.shopping_cart;
      case 'supplier':
        return Icons.store;
      case 'driver':
        return Icons.local_shipping;
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.shopping_cart;
    }
  }

  Color _getUserTypeColor() {
    switch (widget.userType) {
      case 'customer':
        return ThemeService.primaryColor;
      case 'supplier':
        return ThemeService.secondaryColor;
      case 'driver':
        return ThemeService.accentColor;
      case 'admin':
        return ThemeService.steelBlue;
      default:
        return ThemeService.primaryColor;
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      // Navigate to appropriate home screen based on user type
      switch (widget.userType) {
        case 'customer':
          context.go('/client');
          break;
        case 'supplier':
          context.go('/supplier');
          break;
        case 'driver':
          context.go('/driver');
          break;
        case 'admin':
          context.go('/console');
          break;
        default:
          context.go('/client');
      }
    } else if (mounted) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authService.error ?? 'Login failed'),
          backgroundColor: ThemeService.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final userTypeColor = _getUserTypeColor();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              userTypeColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back Button
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/role-selection'),
                      icon: Icon(
                        languageService.isArabic
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_back_ios,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Header
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: userTypeColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getUserTypeIcon(),
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      languageService.getLocalizedText(
                        'تسجيل دخول ${_getUserTypeTitle(languageService)}',
                        '${_getUserTypeTitle(languageService)} Login',
                      ),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: userTypeColor,
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      languageService.getLocalizedText(
                        'أدخل بياناتك للمتابعة',
                        'Enter your credentials to continue',
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Login Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: languageService.email,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageService.getLocalizedText(
                              'يرجى إدخال البريد الإلكتروني',
                              'Please enter email',
                            );
                          }
                          if (!value.contains('@')) {
                            return languageService.getLocalizedText(
                              'يرجى إدخال بريد إلكتروني صحيح',
                              'Please enter a valid email',
                            );
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        decoration: InputDecoration(
                          labelText: languageService.password,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageService.getLocalizedText(
                              'يرجى إدخال كلمة المرور',
                              'Please enter password',
                            );
                          }
                          if (value.length < 6) {
                            return languageService.getLocalizedText(
                              'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                              'Password must be at least 6 characters',
                            );
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: userTypeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  languageService.login,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageService.getLocalizedText(
                              'ليس لديك حساب؟',
                              "Don't have an account?",
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () =>
                                context.go('/register?type=${widget.userType}'),
                            child: Text(
                              languageService.register,
                              style: TextStyle(
                                color: userTypeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
