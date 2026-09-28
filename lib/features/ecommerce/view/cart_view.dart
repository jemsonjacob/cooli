import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/ecommerce/view_model/ecommerce_view_model.dart';
import 'package:cooli/features/ecommerce/view/checkout_view.dart';
import 'package:cooli/utils/cooli_theme.dart';
import 'package:cooli/widgets/cooli_widgets.dart';

class CartView extends StatefulWidget {
  static const String routeName = '/cart';

  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late EcommerceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EcommerceViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: CooliColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: CooliColors.textDark, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'My Cart',
            style: TextStyle(
              color: CooliColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<EcommerceViewModel>(
          builder: (context, vm, child) {
            if (vm.cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 72,
                      color: CooliColors.textLight,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: CooliColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: vm.cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = vm.cartItems[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: CooliShadows.card,
                          border: Border.all(color: CooliColors.border.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          children: [
                            // Product Icon / Thumbnail
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: CooliColors.surfaceAlt,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item.product.category == 'Sand'
                                    ? Icons.waves_rounded
                                    : Icons.grid_view_rounded,
                                color: item.product.category == 'Sand'
                                    ? Colors.amber.shade700
                                    : Colors.deepOrange,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Title & Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: CooliColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${item.product.price.toStringAsFixed(0)} ${item.product.unit}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: CooliColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Quantity Counter
                                  Row(
                                    children: [
                                      Container(
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: CooliColors.surfaceAlt,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 28),
                                              icon: const Icon(Icons.remove, size: 14),
                                              onPressed: () =>
                                                  vm.updateCartItemQuantity(item, -1),
                                            ),
                                            Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: CooliColors.textDark,
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 28),
                                              icon: const Icon(Icons.add, size: 14),
                                              onPressed: () =>
                                                  vm.updateCartItemQuantity(item, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Delete button
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: CooliColors.danger,
                                size: 20,
                              ),
                              onPressed: () => vm.removeCartItem(item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Order Price Breakdown Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: CooliShadows.elevated,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal',
                              style: TextStyle(color: CooliColors.textMuted, fontSize: 14)),
                          Text('₹${vm.subtotal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, color: CooliColors.textDark)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery',
                              style: TextStyle(color: CooliColors.textMuted, fontSize: 14)),
                          Text('₹${vm.deliveryFee.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, color: CooliColors.textDark)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: CooliColors.border),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: CooliColors.textDark,
                            ),
                          ),
                          Text(
                            '₹${vm.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: CooliColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Proceed to Checkout
                      CooliButton(
                        text: 'Proceed to Checkout',
                        showForwardArrow: true,
                        onTap: () {
                          Navigator.pushNamed(context, CheckoutView.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
