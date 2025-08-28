import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/database/database_service.dart';
import '../../../core/models/product.dart';
import '../../../core/models/user.dart';
import '../../chat/screens/chat_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String currentUserId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.currentUserId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _quantity = 1;
  bool _isLoading = false;

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
        parent: _animationController, curve: Curves.easeOutBack));

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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(languageService),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(languageService),
                    _buildDescription(languageService),
                    _buildSpecifications(languageService),
                    _buildSupplierInfo(languageService),
                    _buildReviews(languageService),
                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(languageService),
    );
  }

  Widget _buildSliverAppBar(LanguageService languageService) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFF2E7D32),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: _toggleFavorite,
          icon: const Icon(Icons.favorite_border, color: Colors.white),
        ),
        IconButton(
          onPressed: _shareProduct,
          icon: const Icon(Icons.share, color: Colors.white),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product_${widget.product.id}',
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2E7D32),
                  const Color(0xFF2E7D32).withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _getCategoryIcon(widget.product.category),
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.product.hasDiscount)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${languageService.getLocalizedText('خصم', 'Discount')} ${widget.product.discountPercentage!.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
  }

  Widget _buildProductInfo(LanguageService languageService) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.nameAr,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.nameEn,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ...List.generate(
                  5,
                  (i) => Icon(
                        i < widget.product.rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      )),
              const SizedBox(width: 8),
              Text(
                '${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewCount} ${languageService.getLocalizedText('تقييم', 'reviews')})',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (widget.product.hasDiscount) ...[
                Text(
                  '${widget.product.price.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF999999),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                '${widget.product.finalPrice.toStringAsFixed(2)} ر.س',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.product.inStock
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.product.inStock
                        ? const Color(0xFF4CAF50)
                        : Colors.red,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.product.inStock
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: widget.product.inStock
                          ? const Color(0xFF4CAF50)
                          : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.product.inStock
                          ? languageService.getLocalizedText(
                              'متوفر', 'In Stock')
                          : languageService.getLocalizedText(
                              'غير متوفر', 'Out of Stock'),
                      style: TextStyle(
                        color: widget.product.inStock
                            ? const Color(0xFF4CAF50)
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${languageService.getLocalizedText('الوحدة', 'Unit')}: ${widget.product.unit}',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          if (widget.product.inStock) ...[
            const SizedBox(height: 16),
            Text(
              '${languageService.getLocalizedText('المتوفر', 'Available')}: ${widget.product.stockQuantity} ${widget.product.unit}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescription(LanguageService languageService) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageService.getLocalizedText('الوصف', 'Description'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.descriptionAr,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications(LanguageService languageService) {
    if (widget.product.specifications == null ||
        widget.product.specifications!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageService.getLocalizedText('المواصفات', 'Specifications'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.product.specifications!.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSupplierInfo(LanguageService languageService) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageService.getLocalizedText(
                'معلومات المورد', 'Supplier Information'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFF8D6E63),
                child: const Icon(
                  Icons.store,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شركة مواد البناء المتقدمة', // This should be fetched from supplier data
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(
                            5,
                            (i) => Icon(
                                  i < 4 ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                )),
                        const SizedBox(width: 4),
                        const Text(
                          '4.5 (120 تقييم)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _contactSupplier(),
                icon: const Icon(Icons.chat, size: 16),
                label:
                    Text(languageService.getLocalizedText('تواصل', 'Contact')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviews(LanguageService languageService) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                languageService.getLocalizedText('التقييمات', 'Reviews'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              TextButton(
                onPressed: _showAllReviews,
                child: Text(
                    languageService.getLocalizedText('عرض الكل', 'View All')),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Sample reviews - this should be fetched from database
          _buildReviewItem(
              'أحمد محمد', 5, 'منتج ممتاز وجودة عالية، أنصح به بشدة'),
          const SizedBox(height: 12),
          _buildReviewItem(
              'سارة أحمد', 4, 'جيد جداً ولكن التوصيل كان متأخر قليلاً'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF2E7D32),
                child: Text(
                  name.isNotEmpty ? name[0] : '؟',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                            5,
                            (i) => Icon(
                                  i < rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 14,
                                )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(LanguageService languageService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed:
                      _quantity > 1 ? () => setState(() => _quantity--) : null,
                  icon: const Icon(Icons.remove),
                  color: const Color(0xFF666666),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _quantity.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _quantity < widget.product.stockQuantity
                      ? () => setState(() => _quantity++)
                      : null,
                  icon: const Icon(Icons.add),
                  color: const Color(0xFF666666),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Add to Cart Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  widget.product.inStock && !_isLoading ? _addToCart : null,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.add_shopping_cart),
              label: Text(
                _isLoading
                    ? languageService.getLocalizedText(
                        'جاري الإضافة...', 'Adding...')
                    : languageService.getLocalizedText(
                        'إضافة للسلة', 'Add to Cart'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
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

  void _toggleFavorite() {
    // TODO: Implement favorite functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة المنتج للمفضلة'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _shareProduct() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ رابط المنتج'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  Future<void> _contactSupplier() async {
    final chatId = '${widget.currentUserId}_${widget.product.supplierId}';

    await DatabaseService.instance.addUserToChat(widget.currentUserId, chatId);
    await DatabaseService.instance
        .addUserToChat(widget.product.supplierId, chatId);

    if (mounted) {
      final users = await DatabaseService.instance.getAllUsers();
      final supplier = users.firstWhere(
        (user) => user.id == widget.product.supplierId,
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

  Future<void> _addToCart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize cart service if not already done
      await CartService.instance.initialize(widget.currentUserId);

      // Add product to cart
      final success = await CartService.instance.addToCart(
        widget.product,
        quantity: _quantity,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (success) {
          final languageService =
              Provider.of<LanguageService>(context, listen: false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                languageService.getLocalizedText(
                  'تم إضافة ${_quantity} ${widget.product.unit} من ${widget.product.nameAr} إلى السلة',
                  'Added ${_quantity} ${widget.product.unit} of ${widget.product.nameEn} to cart',
                ),
              ),
              backgroundColor: const Color(0xFF2E7D32),
              action: SnackBarAction(
                label:
                    languageService.getLocalizedText('عرض السلة', 'View Cart'),
                textColor: Colors.white,
                onPressed: () {
                  context.go('/client/cart');
                },
              ),
            ),
          );
        } else {
          final languageService =
              Provider.of<LanguageService>(context, listen: false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                languageService.getLocalizedText(
                  'عذراً، لا يوجد مخزون كافي',
                  'Sorry, not enough stock available',
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        final languageService =
            Provider.of<LanguageService>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              languageService.getLocalizedText(
                'حدث خطأ أثناء إضافة المنتج للسلة',
                'Error adding product to cart',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAllReviews() {
    // TODO: Navigate to reviews screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('عرض جميع التقييمات'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }
}
