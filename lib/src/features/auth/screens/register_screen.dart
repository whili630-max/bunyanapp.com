import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/theme_service.dart';

class RegisterScreen extends StatefulWidget {
  final String userType;

  const RegisterScreen({
    super.key,
    required this.userType,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Provider.of<LanguageService>(context, listen: false)
                .getLocalizedText(
              'يجب الموافقة على الشروط والأحكام',
              'You must accept the terms and conditions',
            ),
          ),
          backgroundColor: ThemeService.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      userType: widget.userType,
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
          content: Text(authService.error ?? 'Registration failed'),
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
                      onPressed: () =>
                          context.go('/login?type=${widget.userType}'),
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
                        'إنشاء حساب ${_getUserTypeTitle(languageService)}',
                        'Create ${_getUserTypeTitle(languageService)} Account',
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
                        'أدخل بياناتك لإنشاء حساب جديد',
                        'Enter your details to create a new account',
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Register Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: languageService.name,
                          prefixIcon: const Icon(Icons.person_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageService.getLocalizedText(
                              'يرجى إدخال الاسم',
                              'Please enter name',
                            );
                          }
                          if (value.length < 2) {
                            return languageService.getLocalizedText(
                              'الاسم يجب أن يكون حرفين على الأقل',
                              'Name must be at least 2 characters',
                            );
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

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

                      // Phone Field
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: languageService.phone,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return languageService.getLocalizedText(
                              'يرجى إدخال رقم الهاتف',
                              'Please enter phone number',
                            );
                          }
                          if (value.length < 10) {
                            return languageService.getLocalizedText(
                              'رقم الهاتف يجب أن يكون 10 أرقام على الأقل',
                              'Phone number must be at least 10 digits',
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
                        textInputAction: TextInputAction.next,
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

                      const SizedBox(height: 20),

                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleRegister(),
                        decoration: InputDecoration(
                          labelText: languageService.confirmPassword,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
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
                              'يرجى تأكيد كلمة المرور',
                              'Please confirm password',
                            );
                          }
                          if (value != _passwordController.text) {
                            return languageService.getLocalizedText(
                              'كلمة المرور غير متطابقة',
                              'Passwords do not match',
                            );
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Terms and Conditions
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            },
                            activeColor: userTypeColor,
                          ),
                          Expanded(
                            child: Text(
                              languageService.getLocalizedText(
                                'أوافق على الشروط والأحكام',
                                'I agree to the terms and conditions',
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
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
                                  languageService.register,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languageService.getLocalizedText(
                              'لديك حساب بالفعل؟',
                              'Already have an account?',
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () =>
                                context.go('/login?type=${widget.userType}'),
                            child: Text(
                              languageService.login,
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
