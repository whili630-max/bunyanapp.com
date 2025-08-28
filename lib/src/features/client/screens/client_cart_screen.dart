import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/theme_service.dart';

class ClientCartScreen extends StatefulWidget {
  const ClientCartScreen({super.key});

  @override
  State<ClientCartScreen> createState() => _ClientCartScreenState();
}

class _ClientCartScreenState extends State<ClientCartScreen> {
  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  void _initializeCart() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.user != null) {
      await CartService.instance.initialize(authService.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageService.getLocalizedText('سلة التسوق', 'Shopping Cart'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: ThemeService.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          ChangeNotifierProvider.value(
            value: CartService.instance,
            child: Consumer<CartService>(
              builder: (context, cartService, child) {
                if (cartService.isNotEmpty) {
                  return IconButton(
                    onPressed: () => _showClearCartDialog(context),
                    icon: const Icon(Icons.delete_outline),
                    tooltip: languageService.getLocalizedText(
                        'مسح السلة', 'Clear Cart'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: CartService.instance,
        child: Consumer<CartService>(
          builder: (context, cartService, child) {
            if (cartService.isEmpty) {
              return _buildEmptyCart(context, languageService);
            }
            return _buildCartContent(context, cartService, languageService);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart(
      BuildContext context, LanguageService languageService) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            languageService.getLocalizedText(
                'سلة التسوق فارغة', 'Cart is Empty'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            languageService.getLocalizedText(
              'ابدأ بإضافة منتجات إلى سلة التسوق',
              'Start adding products to your cart',
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/client/products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeService.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              languageService.getLocalizedText('تسوق الآن', 'Shop Now'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartService cartService,
      LanguageService languageService) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartService.items.length,
            itemBuilder: (context, index) {
              final item = cartService.items[index];
              return _buildCartItem(
                  context, item, cartService, languageService);
            },
          ),
        ),
        _buildCartSummary(context, cartService, languageService),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item,
      CartService cartService, LanguageService languageService) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.construction,
                            color: ThemeService.primaryColor,
                            size: 40,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.construction,
                      color: ThemeService.primaryColor,
                      size: 40,
                    ),
            ),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageService.currentLocale == 'ar'
                        ? item.productNameAr
                        : item.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toStringAsFixed(2)} ${languageService.getLocalizedText('ريال', 'SAR')} / ${item.unit}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Controls
                      Row(
                        children: [
                          IconButton(
                            onPressed: item.quantity > 1
                                ? () => cartService.updateQuantity(
                                    item.productId, item.quantity - 1)
                                : null,
                            icon: const Icon(Icons.remove),
                            iconSize: 20,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: !item.isMaxQuantity
                                ? () => cartService.updateQuantity(
                                    item.productId, item.quantity + 1)
                                : null,
                            icon: const Icon(Icons.add),
                            iconSize: 20,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ),

                      // Total Price
                      Text(
                        '${item.total.toStringAsFixed(2)} ${languageService.getLocalizedText('ريال', 'SAR')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ThemeService.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove Button
            IconButton(
              onPressed: () => _showRemoveItemDialog(
                  context, item, cartService, languageService),
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartService cartService,
      LanguageService languageService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            languageService.getLocalizedText('المجموع الفرعي', 'Subtotal'),
            '${cartService.subtotal.toStringAsFixed(2)} ${languageService.getLocalizedText('ريال', 'SAR')}',
          ),
          _buildSummaryRow(
            languageService.getLocalizedText('الضريبة (15%)', 'Tax (15%)'),
            '${cartService.taxAmount.toStringAsFixed(2)} ${languageService.getLocalizedText('ريال', 'SAR')}',
          ),
          _buildSummaryRow(
            languageService.getLocalizedText('رسوم التوصيل', 'Delivery Fee'),
            '${cartService.deliveryFee.toStringAsFixed(2)} ${languageService.getLocalizedText('ريال', 'SAR')}',
          ),
          const Divider(),
          _buildSummaryRow(
            languageService.getLocalizedText('المجموع الكلي', 'Total'),
            '${cartService.totalAmount.toStringAsFixed(2)} ${languageService.getLocalizedText('ريال', 'SAR')}',
            isTotal: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  _proceedToCheckout(context, cartService, languageService),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeService.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                languageService.getLocalizedText(
                    'متابعة الدفع', 'Proceed to Checkout'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? ThemeService.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveItemDialog(BuildContext context, dynamic item,
      CartService cartService, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(languageService.getLocalizedText('حذف المنتج', 'Remove Item')),
        content: Text(
          languageService.getLocalizedText(
            'هل تريد حذف هذا المنتج من السلة؟',
            'Do you want to remove this item from cart?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(languageService.getLocalizedText('إلغاء', 'Cancel')),
          ),
          TextButton(
            onPressed: () {
              cartService.removeFromCart(item.productId);
              Navigator.of(context).pop();
            },
            child: Text(
              languageService.getLocalizedText('حذف', 'Remove'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(languageService.getLocalizedText('مسح السلة', 'Clear Cart')),
        content: Text(
          languageService.getLocalizedText(
            'هل تريد مسح جميع المنتجات من السلة؟',
            'Do you want to clear all items from cart?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(languageService.getLocalizedText('إلغاء', 'Cancel')),
          ),
          TextButton(
            onPressed: () {
              CartService.instance.clearCart();
              Navigator.of(context).pop();
            },
            child: Text(
              languageService.getLocalizedText('مسح', 'Clear'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context, CartService cartService,
      LanguageService languageService) {
    final errors = cartService.validateCart();
    if (errors.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(languageService.getLocalizedText('خطأ', 'Error')),
          content: Text(errors.first),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(languageService.getLocalizedText('موافق', 'OK')),
            ),
          ],
        ),
      );
      return;
    }

    // TODO: Navigate to checkout screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageService.getLocalizedText(
            'سيتم إضافة صفحة الدفع قريباً',
            'Checkout page coming soon',
          ),
        ),
      ),
    );
  }
}
