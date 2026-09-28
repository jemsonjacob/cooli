import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/onboarding/view_model/onboarding_view_model.dart';
import 'package:cooli/features/auth/view/login_view.dart';
import 'package:cooli/utils/cooli_theme.dart';

class OnboardingView extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late OnboardingViewModel _viewModel;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background soft lavender organic fluid curves
            Positioned(
              top: -60,
              right: -50,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8EBFC).withValues(alpha: 0.7),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE0E5FB).withValues(alpha: 0.7),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -50,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFECEFFD).withValues(alpha: 0.8),
                ),
              ),
            ),

            SafeArea(
              child: Consumer<OnboardingViewModel>(
                builder: (context, vm, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Column(
                      children: [
                        // Top Skip Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, LoginView.routeName);
                              },
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Carousel Content Area with Animated Transition
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: vm.setIndex,
                            itemCount: vm.items.length,
                            itemBuilder: (context, index) {
                              final item = vm.items[index];

                              return AnimatedBuilder(
                                animation: _pageController,
                                builder: (context, child) {
                                  double value = 1.0;
                                  if (_pageController.position.haveDimensions) {
                                    value = (_pageController.page ?? 0) - index;
                                    value = (1 - (value.abs() * 0.25)).clamp(0.0, 1.0);
                                  }
                                  return Opacity(
                                    opacity: value.clamp(0.4, 1.0),
                                    child: Transform.scale(
                                      scale: value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Title
                                    Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        height: 1.25,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Subtitle
                                    Text(
                                      item.description,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF64748B),
                                        height: 1.4,
                                      ),
                                    ),

                                    const SizedBox(height: 28),

                                    // 3D Illustration Graphic Card
                                    Container(
                                      width: 260,
                                      height: 260,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFEFF2FE),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF3B5AFB).withValues(alpha: 0.12),
                                            blurRadius: 30,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          item.imagePath,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.local_shipping_rounded,
                                                size: 90,
                                                color: CooliColors.primary,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Animated Indicator Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            vm.items.length,
                            (index) {
                              final isSelected = vm.currentIndex == index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: isSelected ? 22 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF3B5AFB)
                                      : const Color(0xFFCBD5E1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Get Started / Next Button
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B5AFB), Color(0xFF4338CA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B5AFB).withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(26),
                              onTap: () {
                                if (vm.currentIndex < vm.items.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOutCubic,
                                  );
                                } else {
                                  Navigator.pushReplacementNamed(context, LoginView.routeName);
                                }
                              },
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      vm.currentIndex == vm.items.length - 1
                                          ? 'Get Started'
                                          : 'Next',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
