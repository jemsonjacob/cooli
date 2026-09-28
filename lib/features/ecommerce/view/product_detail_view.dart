import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/ecommerce/model/product_model.dart';
import 'package:cooli/features/ecommerce/view_model/ecommerce_view_model.dart';
import 'package:cooli/features/ecommerce/view/checkout_view.dart';
import 'package:cooli/utils/cooli_theme.dart';
import 'package:cooli/widgets/cooli_widgets.dart';

class ProductDetailView extends StatefulWidget {
  static const String routeName = '/product-detail';
  final ProductModel? product;

  const ProductDetailView({super.key, this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late EcommerceViewModel _viewModel;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _viewModel = EcommerceViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product ??
        _viewModel.products.firstWhere(
          (p) => p.id == 'prod_sand',
          orElse: () => const ProductModel(
            id: 'prod_sand',
            title: 'River Sand',
            category: 'Sand',
            price: 1200,
            unit: '/m³',
            rating: 4.5,
            reviewCount: 120,
            inStock: true,
            description: 'High quality river sand suitable for construction and plastering.',
            imageUrl: '',
          ),
        );

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<EcommerceViewModel>(
            builder: (context, vm, child) {
              return Column(
                children: [
                  // Custom App Bar with Back & Favorite
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: CooliColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: CooliColors.textDark,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: CooliColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 20,
                              color: _isFavorite ? Colors.redAccent : CooliColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Large Product Graphic Image Container
                          Container(
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: CooliColors.softHeroGradient,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: CooliColors.primarySoft),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (product.imageUrl.isNotEmpty)
                                    SizedBox(
                                      height: 120,
                                      child: Image.asset(
                                        product.imageUrl,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    )
                                  else
                                    Icon(
                                      product.category == 'Sand'
                                          ? Icons.waves_rounded
                                          : Icons.grid_view_rounded,
                                      size: 90,
                                      color: product.category == 'Sand'
                                          ? Colors.amber.shade700
                                          : Colors.deepOrange,
                                    ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Certified Premium Grade',
                                      style: TextStyle(
                                        color: CooliColors.primaryDark,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Title
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: CooliColors.textDark,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Rating & In Stock Badge
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${product.rating}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${product.reviewCount} reviews)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CooliColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (product.inStock)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: CooliColors.successSoft,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'In Stock',
                                    style: TextStyle(
                                      color: CooliColors.success,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '₹${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: CooliColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.unit,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CooliColors.textMuted,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: CooliColors.textMuted,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Quantity Stepper
                          Row(
                            children: [
                              const Text(
                                'Quantity:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CooliColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: CooliColors.surfaceAlt,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: CooliColors.border),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 16),
                                      onPressed: () => vm.setProductQuantity(vm.productQuantity - 1),
                                    ),
                                    Text(
                                      '${vm.productQuantity}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: CooliColors.textDark,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 16),
                                      onPressed: () => vm.setProductQuantity(vm.productQuantity + 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Buttons
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: CooliShadows.elevated,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CooliOutlineButton(
                            text: 'Add to Cart',
                            onTap: () {
                              vm.addToCart(product, quantity: vm.productQuantity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to Cart!'),
                                  backgroundColor: CooliColors.primary,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CooliButton(
                            text: 'Buy Now',
                            onTap: () {
                              vm.addToCart(product, quantity: vm.productQuantity);
                              Navigator.pushNamed(context, CheckoutView.routeName);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
