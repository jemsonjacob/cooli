import 'package:flutter/material.dart';
import 'package:cooli/features/dashboard/view/main_navigation_view.dart';
import 'package:cooli/utils/cooli_theme.dart';
import 'package:cooli/widgets/cooli_widgets.dart';

class ServiceConfirmedView extends StatelessWidget {
  static const String routeName = '/service-confirmed';

  const ServiceConfirmedView({super.key});

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

              // Expert Service Professional Graphic Container
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  gradient: CooliColors.softHeroGradient,
                  shape: BoxShape.circle,
                  boxShadow: CooliShadows.card,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.engineering_rounded,
                      size: 80,
                      color: CooliColors.primary,
                    ),
                    Positioned(
                      right: 25,
                      bottom: 25,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: CooliColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: CooliColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your service has been booked successfully.\nA verified professional will arrive on time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: CooliColors.textMuted,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              // Booking ID Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: CooliColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Booking #BK1234',
                  style: TextStyle(
                    color: CooliColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const Spacer(),

              CooliButton(
                text: 'Track Booking',
                showForwardArrow: true,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainNavigationView.routeName,
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 12),

              CooliOutlineButton(
                text: 'View Details',
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
