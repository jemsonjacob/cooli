import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/splash/view_model/splash_view_model.dart';
import 'package:cooli/features/onboarding/view/onboarding_view.dart';

class SplashView extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late SplashViewModel _viewModel;
  late AnimationController _entranceController;
  late AnimationController _idleController;

  // Staggered Animations
  late Animation<Offset> _bar1Anim;
  late Animation<Offset> _bar2Anim;
  late Animation<Offset> _bar3Anim;
  late Animation<double> _titleScale;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<Offset> _truckSlide;
  late Animation<double> _truckScale;
  late Animation<double> _truckFade;
  late Animation<double> _waveProgress;
  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _idleFloat;

  Timer? _navTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel();
    _viewModel.initSplash();

    // 1. Entrance Controller (1.4s)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // 2. Idle Floating Controller (2.4s loop)
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // Speed bars staggered slide from left
    _bar1Anim = Tween<Offset>(begin: const Offset(-2.0, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _bar2Anim = Tween<Offset>(begin: const Offset(-2.5, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.1, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _bar3Anim = Tween<Offset>(begin: const Offset(-3.0, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.65, curve: Curves.easeOutBack),
      ),
    );

    // Brand Title Pop & Fade
    _titleScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.5, curve: Curves.easeIn),
      ),
    );

    // Subtitle
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeIn),
      ),
    );
    _subtitleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    // 3D Truck Entrance (Drive in from left with smooth spring bounce)
    _truckSlide = Tween<Offset>(begin: const Offset(-0.35, 0.0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _truckScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutBack),
      ),
    );
    _truckFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeIn),
      ),
    );

    // Wave Rise
    _waveProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.85, curve: Curves.easeOutQuart),
      ),
    );

    // Tagline Entrance
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.95, curve: Curves.easeIn),
      ),
    );
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.95, curve: Curves.easeOutBack),
      ),
    );

    // Idle floating oscillation (simulates running engine suspension)
    _idleFloat = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _idleController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Start Entrance and subsequent Idle loop
    _entranceController.forward().then((_) {
      if (mounted) {
        _idleController.repeat(reverse: true);
      }
    });

    // Auto navigate with smooth transition exactly once after 3.0s
    _navTimer = Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _navigateToOnboarding();
      }
    });
  }

  void _navigateToOnboarding() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    Navigator.of(context).pushNamedAndRemoveUntil(
      OnboardingView.routeName,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _entranceController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // 1. Bottom Organic Wave Decoration with Animated Height Rise
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _waveProgress,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(screenSize.width, 220 * _waveProgress.value),
                    painter: _SplashBottomWavePainter(),
                  );
                },
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 36),

                  // 2. Top Logo & Title with Staggered Animations
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 3-tier Staggered Speed Bars
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SlideTransition(
                                  position: _bar1Anim,
                                  child: Container(
                                    width: 34,
                                    height: 5.5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2563EB),
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.5),
                                SlideTransition(
                                  position: _bar2Anim,
                                  child: Container(
                                    width: 26,
                                    height: 5.5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF38BDF8),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.5),
                                SlideTransition(
                                  position: _bar3Anim,
                                  child: Container(
                                    width: 18,
                                    height: 5.5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF60A5FA),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Brand Name
                            ScaleTransition(
                              scale: _titleScale,
                              child: FadeTransition(
                                opacity: _titleFade,
                                child: const Text(
                                  'Cooli',
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2563EB),
                                    letterSpacing: -0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Subtitle
                        SlideTransition(
                          position: _subtitleSlide,
                          child: FadeTransition(
                            opacity: _subtitleFade,
                            child: const Text(
                              'Your Everyday Logistics Partner',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475569),
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // 3. Center 3D Transparent Truck Illustration with Engine Vibration Animation
                  SlideTransition(
                    position: _truckSlide,
                    child: ScaleTransition(
                      scale: _truckScale,
                      child: FadeTransition(
                        opacity: _truckFade,
                        child: AnimatedBuilder(
                          animation: _idleFloat,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _idleFloat.value),
                              child: child,
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Soft oval ground shadow underneath truck
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  width: screenSize.width * 0.70,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.all(
                                      Radius.elliptical(screenSize.width * 0.70, 20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.10),
                                        blurRadius: 18,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Seamless Transparent 3D Delivery Truck
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Image.asset(
                                  'assets/images/splash_truck_clean.png',
                                  width: screenSize.width * 0.88,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    'assets/images/cooli_truck_exact.png',
                                    width: screenSize.width * 0.88,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // 4. Bottom Tagline with Fade & Slide inside Wave
                  SlideTransition(
                    position: _taglineSlide,
                    child: FadeTransition(
                      opacity: _taglineFade,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 36.0),
                        child: Text(
                          'Faster   •   Safer   •   Smarter',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.9),
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.height <= 0) return;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFDCE2FC),
          Color(0xFFE9ECFD),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * 0.40);
    path.cubicTo(
      size.width * 0.30,
      size.height * 0.42,
      size.width * 0.65,
      size.height * 0.78,
      size.width,
      size.height * 0.66,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
