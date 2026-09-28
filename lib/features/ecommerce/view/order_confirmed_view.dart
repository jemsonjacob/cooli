import 'package:flutter/material.dart';
import 'package:cooli/features/ecommerce/view/track_order_view.dart';
import 'package:cooli/features/dashboard/view/main_navigation_view.dart';
import 'package:cooli/utils/cooli_theme.dart';
import 'package:cooli/widgets/cooli_widgets.dart';

class OrderConfirmedView extends StatelessWidget {
  static const String routeName = '/order-confirmed';

  const OrderConfirmedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // 3D Package Box Illustration Container
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  gradient: CooliColors.softHeroGradient,
                  shape: BoxShape.circle,
                  boxShadow: CooliShadows.card,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.inventory_2_rounded,
                      size: 90,
                      color: CooliColors.primary,
                    ),
                    Positioned(
                      right: 30,
                      bottom: 30,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: CooliColors.success,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3310B981),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: CooliColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your order has been successfully placed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: CooliColors.textMuted,
                ),
              ),

              const SizedBox(height: 16),

              // Order ID Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: CooliColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Order #CO12345',
                  style: TextStyle(
                    color: CooliColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const Spacer(),

              // Action Buttons
              CooliButton(
                text: 'Track Order',
                showForwardArrow: true,
                onTap: () {
                  Navigator.pushNamed(context, TrackOrderView.routeName);
                },
              ),

              const SizedBox(height: 12),

              CooliOutlineButton(
                text: 'Continue Shopping',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainNavigationView.routeName,
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
