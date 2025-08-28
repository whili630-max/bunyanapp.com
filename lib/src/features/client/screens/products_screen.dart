import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../../../core/database/database_service.dart';
import '../../../core/models/product.dart';
import '../../../core/models/user.dart';
import '../../chat/screens/chat_screen.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String? category;
  final String currentUserId;

  const ProductsScreen({
    super.key,
    this.category,
    required this.currentUserId,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategory;
  String _sortBy = 'name';
  bool _isGridView = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadProducts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await DatabaseService.instance.getProducts(
        category: _selectedCategory,
      );

      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });

      _animationController.forward();
      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = _searchQuery.isEmpty ||
            product.nameAr.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.nameEn.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesCategory =
            _selectedCategory == null || product.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();

      // Apply sorting
      switch (_sortBy) {
        case 'name':
          _filteredProducts.sort((a, b) => a.nameAr.compareTo(b.nameAr));
          break;
        case 'price_low':
          _filteredProducts
              .sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
          break;
        case 'price_high':
          _filteredProducts
              .sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
          break;
        case 'rating':
          _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          _selectedCategory != null
              ? (ProductCategory.names[_selectedCategory]?['ar'] ?? 'المنتجات')
              : languageService.getLocalizedText('المنتجات', 'Products'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(
              _isGridView ? Icons.list : Icons.grid_view,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: _showSortOptions,
            icon: const Icon(Icons.sort, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(languageService),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                    ),
                  )
                : _filteredProducts.isEmpty
                    ? _buildEmptyState(languageService)
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child:
                            _isGridView ? _buildGridView() : _buildListView(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(LanguageService languageService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _applyFilters();
              },
              decoration: InputDecoration(
                hintText: languageService.getLocalizedText(
                    'البحث عن المنتجات', 'Search products'),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF666666)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          _applyFilters();
                        },
                        icon: const Icon(Icons.clear, color: Color(0xFF666666)),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ProductCategory.all.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildCategoryChip(
                    null,
                    languageService.getLocalizedText('الكل', 'All'),
                    languageService,
                  );
                }

                final category = ProductCategory.all[index - 1];
                final name = ProductCategory.names[category]?['ar'] ?? category;

                return _buildCategoryChip(category, name, languageService);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      String? category, String name, LanguageService languageService) {
    final isSelected = _selectedCategory == category;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2E7D32),
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
          });
          _applyFilters();
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF1B5E20),
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color:
                isSelected ? const Color(0xFF1B5E20) : const Color(0xFF2E7D32),
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_filteredProducts[index], index);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductListItem(_filteredProducts[index], index);
      },
    );
  }

  Widget _buildProductCard(Product product, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Hero(
              tag: 'product_${product.id}',
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () => _openProductDetail(product),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  _getCategoryIcon(product.category),
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                              ),
                              if (product.hasDiscount)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${product.discountPercentage!.toInt()}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    product.inStock
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: product.inStock
                                        ? Colors.green
                                        : Colors.red,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Product Info
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.nameAr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  ...List.generate(
                                      5,
                                      (i) => Icon(
                                            i < product.rating.floor()
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 12,
                                          )),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${product.reviewCount})',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  if (product.hasDiscount) ...[
                                    Text(
                                      '${product.price.toStringAsFixed(2)} ر.س',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF999999),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    '${product.finalPrice.toStringAsFixed(2)} ر.س',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductListItem(Product product, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _openProductDetail(product),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Product Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getCategoryIcon(product.category),
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.nameAr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.descriptionAr,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ...List.generate(
                                    5,
                                    (i) => Icon(
                                          i < product.rating.floor()
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 14,
                                        )),
                                const SizedBox(width: 4),
                                Text(
                                  '(${product.reviewCount})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Price and Actions
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (product.hasDiscount) ...[
                            Text(
                              '${product.price.toStringAsFixed(2)} ر.س',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            '${product.finalPrice.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _contactSupplier(product),
                                icon: const Icon(
                                  Icons.chat,
                                  color: Color(0xFF2E7D32),
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _addToCart(product),
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  color: Color(0xFF2E7D32),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(LanguageService languageService) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 60,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            languageService.getLocalizedText(
                'لا توجد منتجات', 'No products found'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            languageService.getLocalizedText(
              'جرب تغيير معايير البحث أو الفلترة',
              'Try changing your search or filter criteria',
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'cement':
        return Icons.construction;
      case 'steel':
        return Icons.hardware;
      case 'bricks':
        return Icons.view_module;
      case 'tiles':
        return Icons.grid_view;
      case 'tools':
        return Icons.build;
      case 'electrical':
        return Icons.electrical_services;
      case 'plumbing':
        return Icons.plumbing;
      default:
        return Icons.inventory_2;
    }
  }

  void _openProductDetail(Product product) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(
          product: product,
          currentUserId: widget.currentUserId,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _showSortOptions() {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageService.getLocalizedText('ترتيب حسب', 'Sort by'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildSortOption(
                'name', languageService.getLocalizedText('الاسم', 'Name')),
            _buildSortOption(
                'price_low',
                languageService.getLocalizedText(
                    'السعر: من الأقل للأعلى', 'Price: Low to High')),
            _buildSortOption(
                'price_high',
                languageService.getLocalizedText(
                    'السعر: من الأعلى للأقل', 'Price: High to Low')),
            _buildSortOption('rating',
                languageService.getLocalizedText('التقييم', 'Rating')),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String value, String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _sortBy,
      onChanged: (newValue) {
        setState(() {
          _sortBy = newValue!;
        });
        _applyFilters();
        Navigator.pop(context);
      },
      activeColor: const Color(0xFF2E7D32),
    );
  }

  Future<void> _contactSupplier(Product product) async {
    final chatId = '${widget.currentUserId}_${product.supplierId}';

    await DatabaseService.instance.addUserToChat(widget.currentUserId, chatId);
    await DatabaseService.instance.addUserToChat(product.supplierId, chatId);

    if (mounted) {
      final users = await DatabaseService.instance.getAllUsers();
      final supplier = users.firstWhere(
        (user) => user.id == product.supplierId,
        orElse: () => User(
          id: 'unknown',
          name: 'مورد غير معروف',
          email: '',
          password: '',
          userType: UserType.supplier,
          phone: '',
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: chatId,
            chatName: supplier.name,
            currentUserId: widget.currentUserId,
          ),
        ),
      );
    }
  }

  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة ${product.nameAr} إلى السلة'),
        backgroundColor: const Color(0xFF2E7D32),
        action: SnackBarAction(
          label: 'عرض السلة',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Navigate to cart
          },
        ),
      ),
    );
  }
}
