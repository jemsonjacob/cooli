import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/ecommerce/view_model/ecommerce_view_model.dart';
import 'package:cooli/features/ecommerce/view/product_detail_view.dart';
import 'package:cooli/features/ecommerce/view/cart_view.dart';
import 'package:cooli/features/profile/view/profile_view.dart';
import 'package:cooli/features/ecommerce/model/product_model.dart';

class EcommerceHomeView extends StatefulWidget {
  static const String routeName = '/ecommerce';

  const EcommerceHomeView({super.key});

  @override
  State<EcommerceHomeView> createState() => _EcommerceHomeViewState();
}

class _EcommerceHomeViewState extends State<EcommerceHomeView> {
  late EcommerceViewModel _viewModel;
  int _selectedBottomNav = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = EcommerceViewModel();
    _viewModel.filterCategory('All');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFE),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827), size: 24),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'E-Commerce',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          actions: [
            Consumer<EcommerceViewModel>(
              builder: (context, vm, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF111827), size: 22),
                      onPressed: () {
                        Navigator.pushNamed(context, CartView.routeName);
                      },
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Center(
                          child: Text(
                            '${vm.cartItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Consumer<EcommerceViewModel>(
          builder: (context, vm, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(Icons.search_rounded, color: Color(0xFF9CA3AF), size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search sand, bricks...',
                              hintStyle: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              filled: false,
                              fillColor: Colors.transparent,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Hero Banner: "Quality Sand & Bricks for Your Construction"
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E293B).withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/images/ecom_hero_clean.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Category Filter Pills (Matching exact UI reference)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. Sand
                      _buildCategoryItem(
                        name: 'Sand',
                        assetPath: 'assets/images/cat_sand_icon.png',
                        fallbackIcon: Icons.waves_rounded,
                        bgColor: const Color(0xFFFDF6EE),
                        borderColor: const Color(0xFFFDE68A),
                        textColor: const Color(0xFF78350F),
                        isSelected: vm.selectedCategory == 'Sand' || vm.selectedCategory == 'All',
                        onTap: () => vm.filterCategory('Sand'),
                      ),
                      const SizedBox(width: 8),
                      // 2. Bricks
                      _buildCategoryItem(
                        name: 'Bricks',
                        assetPath: 'assets/images/cat_bricks_icon.png',
                        fallbackIcon: Icons.view_in_ar_rounded,
                        bgColor: const Color(0xFFF3F4FD),
                        borderColor: const Color(0xFFE0E7FF),
                        textColor: const Color(0xFF4F46E5),
                        isSelected: vm.selectedCategory == 'Bricks',
                        onTap: () => vm.filterCategory('Bricks'),
                      ),
                      const SizedBox(width: 8),
                      // 3. Cement
                      _buildCategoryItem(
                        name: 'Cement',
                        assetPath: 'assets/images/cat_cement_icon.png',
                        fallbackIcon: Icons.inventory_2_outlined,
                        bgColor: const Color(0xFFF8FAFC),
                        borderColor: const Color(0xFFE2E8F0),
                        textColor: const Color(0xFF475569),
                        isSelected: vm.selectedCategory == 'Cement',
                        onTap: () => vm.filterCategory('Cement'),
                      ),
                      const SizedBox(width: 8),
                      // 4. Aggregates
                      _buildCategoryItem(
                        name: 'Aggregates',
                        assetPath: 'assets/images/cat_aggregates_icon.png',
                        fallbackIcon: Icons.layers_outlined,
                        bgColor: const Color(0xFFF8FAFC),
                        borderColor: const Color(0xFFE2E8F0),
                        textColor: const Color(0xFF475569),
                        isSelected: vm.selectedCategory == 'Aggregates',
                        onTap: () => vm.filterCategory('Aggregates'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Popular Products Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Popular Products',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // 2-Column Product Grid (River Sand & Red Bricks)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.74,
                    ),
                    itemCount: vm.products.length,
                    itemBuilder: (context, index) {
                      final product = vm.products[index];
                      return _buildProductCard(context, vm, product);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(0, Icons.home_rounded, 'Home'),
                  _buildBottomNavItem(1, Icons.grid_view_rounded, 'Categories'),
                  Consumer<EcommerceViewModel>(
                    builder: (context, vm, _) => _buildBottomNavItem(
                      2,
                      Icons.shopping_bag_outlined,
                      'Cart',
                      badgeCount: vm.cartItems.length,
                    ),
                  ),
                  _buildBottomNavItem(3, Icons.person_outline_rounded, 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label, {int badgeCount = 0}) {
    final isSelected = _selectedBottomNav == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBottomNav = index;
        });
        if (index == 0) {
          _viewModel.filterCategory('All');
        } else if (index == 1) {
          _viewModel.filterCategory('All');
        } else if (index == 2) {
          Navigator.pushNamed(context, CartView.routeName).then((_) {
            if (mounted) setState(() => _selectedBottomNav = 0);
          });
        } else if (index == 3) {
          Navigator.pushNamed(context, ProfileView.routeName).then((_) {
            if (mounted) setState(() => _selectedBottomNav = 0);
          });
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEEF2FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF9CA3AF),
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required String name,
    required String assetPath,
    required IconData fallbackIcon,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 26,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Icon(
                    fallbackIcon,
                    size: 22,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, EcommerceViewModel vm, ProductModel product) {
    final imageAsset = product.imageUrl.isNotEmpty
        ? product.imageUrl
        : (product.category.toLowerCase() == 'sand'
            ? 'assets/images/ecom_sand_clean.png'
            : 'assets/images/ecom_bricks_clean.png');

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailView.routeName,
          arguments: product,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product 3D Image
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => Icon(
                      product.category == 'Sand' ? Icons.waves_rounded : Icons.view_in_ar_rounded,
                      size: 44,
                      color: const Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Product Title
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            // Price & Unit
            Row(
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  product.unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: () {
                  vm.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} added to cart!'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: const Color(0xFF1E1B4B),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B69FD),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
