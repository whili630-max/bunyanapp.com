import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/theme_service.dart';

class ModernClientHomeScreen extends StatefulWidget {
  const ModernClientHomeScreen({super.key});

  @override
  State<ModernClientHomeScreen> createState() => _ModernClientHomeScreenState();
}

class _ModernClientHomeScreenState extends State<ModernClientHomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Widget> _screens = [
    const ModernClientHomeTab(),
    const ModernClientProductsTab(),
    const ModernClientCartTab(),
    const ModernClientOrdersTab(),
    const ModernClientProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _screens[_currentIndex],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _animationController.reset();
            _animationController.forward();
          },
          selectedItemColor: ThemeService.primaryColor,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          backgroundColor: Colors.white,
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
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: ThemeService.errorColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
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
      ),
    );
  }
}

class ModernClientHomeTab extends StatefulWidget {
  const ModernClientHomeTab({super.key});

  @override
  State<ModernClientHomeTab> createState() => _ModernClientHomeTabState();
}

class _ModernClientHomeTabState extends State<ModernClientHomeTab>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _categoriesAnimationController;
  late AnimationController _productsAnimationController;

  late Animation<double> _headerAnimation;
  late Animation<double> _categoriesAnimation;
  late Animation<double> _productsAnimation;

  @override
  void initState() {
    super.initState();

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _categoriesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _productsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _headerAnimationController, curve: Curves.easeOut),
    );
    _categoriesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _categoriesAnimationController, curve: Curves.easeOut),
    );
    _productsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _productsAnimationController, curve: Curves.easeOut),
    );

    // Staggered animations
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _categoriesAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _productsAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _categoriesAnimationController.dispose();
    _productsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: ThemeService.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
                animation: _headerAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _headerAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ThemeService.primaryColor,
                            ThemeService.primaryColor.withOpacity(0.8),
                            ThemeService.steelBlue,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      Icons.construction,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        const SizedBox(height: 5),
                                        Text(
                                          languageService.getLocalizedText(
                                            'سوق مواد البناء الأول في السعودية',
                                            'Saudi Arabia\'s Premier Construction Marketplace',
                                          ),
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined,
                        color: Colors.white),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ThemeService.errorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - _headerAnimation.value)),
                  child: Opacity(
                    opacity: _headerAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: languageService.getLocalizedText(
                              'ابحث عن مواد البناء...',
                              'Search for construction materials...',
                            ),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_list,
                                  color: Colors.grey),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Categories Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _categoriesAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - _categoriesAnimation.value)),
                  child: Opacity(
                    opacity: _categoriesAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languageService.getLocalizedText(
                                    'الفئات', 'Categories'),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  languageService.getLocalizedText(
                                      'عرض الكل', 'View All'),
                                  style: TextStyle(
                                    color: ThemeService.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _constructionCategories.length,
                              itemBuilder: (context, index) {
                                final category = _constructionCategories[index];
                                return AnimatedContainer(
                                  duration: Duration(
                                      milliseconds: 300 + (index * 100)),
                                  margin: const EdgeInsets.only(right: 15),
                                  child: _buildModernCategoryCard(
                                    context: context,
                                    title: languageService.getLocalizedText(
                                      category['titleAr']!,
                                      category['titleEn']!,
                                    ),
                                    icon: category['icon'] as IconData,
                                    color: category['color'] as Color,
                                    gradient:
                                        category['gradient'] as List<Color>,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),

          // Featured Products Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _productsAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - _productsAnimation.value)),
                  child: Opacity(
                    opacity: _productsAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languageService.getLocalizedText(
                                  'منتجات مميزة',
                                  'Featured Products',
                                ),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  languageService.getLocalizedText(
                                      'عرض الكل', 'View All'),
                                  style: TextStyle(
                                    color: ThemeService.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _featuredProducts.length,
                              itemBuilder: (context, index) {
                                final product = _featuredProducts[index];
                                return AnimatedContainer(
                                  duration: Duration(
                                      milliseconds: 400 + (index * 100)),
                                  margin: const EdgeInsets.only(right: 15),
                                  child: _buildModernProductCard(
                                    context: context,
                                    product: product,
                                    languageService: languageService,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildModernCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required List<Color> gradient,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
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
    );
  }

  Widget _buildModernProductCard({
    required BuildContext context,
    required Map<String, dynamic> product,
    required LanguageService languageService,
  }) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: product['gradient'] as List<Color>,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    product['icon'] as IconData,
                    size: 60,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeService.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      languageService.getLocalizedText('متوفر', 'Available'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageService.getLocalizedText(
                    product['nameAr']!,
                    product['nameEn']!,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  languageService.getLocalizedText(
                    product['descriptionAr']!,
                    product['descriptionEn']!,
                  ),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product['price']} ${languageService.getLocalizedText('ريال', 'SAR')}',
                          style: TextStyle(
                            color: ThemeService.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          languageService.getLocalizedText(
                              'للوحدة', 'per unit'),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: ThemeService.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Construction Categories Data
  final List<Map<String, dynamic>> _constructionCategories = [
    {
      'titleAr': 'أسمنت',
      'titleEn': 'Cement',
      'icon': Icons.construction,
      'color': ThemeService.cementGray,
      'gradient': [ThemeService.cementGray, ThemeService.steelBlue],
    },
    {
      'titleAr': 'حديد',
      'titleEn': 'Steel',
      'icon': Icons.hardware,
      'color': ThemeService.steelBlue,
      'gradient': [ThemeService.steelBlue, ThemeService.primaryColor],
    },
    {
      'titleAr': 'طوب',
      'titleEn': 'Bricks',
      'icon': Icons.view_module,
      'color': ThemeService.brickRed,
      'gradient': [ThemeService.brickRed, ThemeService.secondaryColor],
    },
    {
      'titleAr': 'بلاط',
      'titleEn': 'Tiles',
      'icon': Icons.grid_view,
      'color': ThemeService.primaryColor,
      'gradient': [ThemeService.primaryColor, ThemeService.successColor],
    },
    {
      'titleAr': 'أدوات',
      'titleEn': 'Tools',
      'icon': Icons.build,
      'color': ThemeService.accentColor,
      'gradient': [ThemeService.accentColor, ThemeService.warningColor],
    },
    {
      'titleAr': 'كهرباء',
      'titleEn': 'Electrical',
      'icon': Icons.electrical_services,
      'color': ThemeService.arabicGold,
      'gradient': [ThemeService.arabicGold, ThemeService.accentColor],
    },
  ];

  // Featured Products Data
  final List<Map<String, dynamic>> _featuredProducts = [
    {
      'nameAr': 'أسمنت بورتلاند',
      'nameEn': 'Portland Cement',
      'descriptionAr': 'أسمنت عالي الجودة للبناء',
      'descriptionEn': 'High-quality cement for construction',
      'price': 25,
      'icon': Icons.construction,
      'gradient': [ThemeService.cementGray, ThemeService.steelBlue],
    },
    {
      'nameAr': 'حديد تسليح 12مم',
      'nameEn': 'Rebar 12mm',
      'descriptionAr': 'حديد تسليح عالي المقاومة',
      'descriptionEn': 'High-strength reinforcement steel',
      'price': 2800,
      'icon': Icons.hardware,
      'gradient': [ThemeService.steelBlue, ThemeService.primaryColor],
    },
    {
      'nameAr': 'طوب أحمر',
      'nameEn': 'Red Bricks',
      'descriptionAr': 'طوب أحمر عالي الجودة',
      'descriptionEn': 'High-quality red bricks',
      'price': 0.75,
      'icon': Icons.view_module,
      'gradient': [ThemeService.brickRed, ThemeService.secondaryColor],
    },
    {
      'nameAr': 'بلاط سيراميك',
      'nameEn': 'Ceramic Tiles',
      'descriptionAr': 'بلاط سيراميك فاخر',
      'descriptionEn': 'Premium ceramic tiles',
      'price': 45,
      'icon': Icons.grid_view,
      'gradient': [ThemeService.primaryColor, ThemeService.successColor],
    },
  ];
}

// Placeholder tabs for other sections
class ModernClientProductsTab extends StatelessWidget {
  const ModernClientProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context)
            .getLocalizedText('المنتجات', 'Products')),
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Modern Products Tab - Coming Soon'),
      ),
    );
  }
}

class ModernClientCartTab extends StatelessWidget {
  const ModernClientCartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context).cart),
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Modern Cart Tab - Coming Soon'),
      ),
    );
  }
}

class ModernClientOrdersTab extends StatelessWidget {
  const ModernClientOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LanguageService>(context).orders),
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Modern Orders Tab - Coming Soon'),
      ),
    );
  }
}

class ModernClientProfileTab extends StatelessWidget {
  const ModernClientProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.profile),
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeService.primaryColor, ThemeService.steelBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authService.user?.email ??
                            languageService.getLocalizedText('مستخدم', 'User'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        languageService.customer,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Logout Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                languageService.logout,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                await authService.signOut();
                if (context.mounted) {
                  // Navigation will be handled by the router's redirect logic
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
