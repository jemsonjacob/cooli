import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/ride/view_model/ride_view_model.dart';
import 'package:cooli/features/ride/view/ride_completed_view.dart';

class RideTrackingView extends StatefulWidget {
  static const String routeName = '/ride-tracking';

  const RideTrackingView({super.key});

  @override
  State<RideTrackingView> createState() => _RideTrackingViewState();
}

class _RideTrackingViewState extends State<RideTrackingView>
    with SingleTickerProviderStateMixin {
  late RideViewModel _viewModel;
  late AnimationController _carAnimController;
  late Animation<double> _carProgress;

  @override
  void initState() {
    super.initState();
    _viewModel = RideViewModel();
    _carAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _carProgress = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _carAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _carAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFF090F1D), // Rich dark map background
        body: Column(
          children: [
            // 1. TOP HALF: Interactive Dark Map with animated route, car, and floating badges
            Expanded(
              flex: 11,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Animated Map Canvas
                  AnimatedBuilder(
                    animation: _carProgress,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _UberDarkMapPainter(progress: _carProgress.value),
                      );
                    },
                  ),

                  // Top Floating Header: Back Button + "On the way" + Refresh
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Back Button Pill
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24, width: 1.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // "On the way" Green Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF064E3B).withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: const Color(0xFF10B981), width: 1.3),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF34D399),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'On the way',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Map Center Action Button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 1.2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.sync_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. BOTTOM HALF: Floating White Driver Details Card
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 24,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle Bar Indicator
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Driver Profile Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Driver Avatar
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/ride_driver_avatar.png',
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person_rounded,
                                size: 30,
                                color: Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Driver Name, Star Rating & Vehicle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Rahul Kumar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                                  SizedBox(width: 2),
                                  Text(
                                    '4.9',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Toyota Etios  •  KL 07 AB 1234',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ETA Banner: "Arriving in 4 min"
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1E1B4B),
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(text: 'Arriving in '),
                              TextSpan(
                                text: '4 min',
                                style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 3 Action Buttons: Call, OTP, Chat
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionTile(
                            icon: Icons.phone_rounded,
                            label: 'Call',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calling Rahul Kumar (+91 98765 43210)...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildActionTile(
                            icon: Icons.pin_rounded,
                            label: 'OTP: 4219',
                            isHighlighted: true,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildActionTile(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'Chat',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Opening chat with driver...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Complete Ride Button (Takes user to Ride Completed)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RideCompletedView.routeName,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Simulate Arrival / End Ride',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Cancel Ride Button
                    TextButton(
                      onPressed: () => Navigator.maybePop(context),
                      child: const Text(
                        'Cancel Ride',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isHighlighted ? const Color(0xFF4F46E5) : const Color(0xFF475569),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
                color: isHighlighted ? const Color(0xFF0F172A) : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UberDarkMapPainter extends CustomPainter {
  final double progress;

  _UberDarkMapPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // 1. Dark Background Fill
    final bgPaint = Paint()..color = const Color(0xFF0D1424);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. City Block Background Tiles (subtle 3D land parcels)
    final blockPaint = Paint()..color = const Color(0xFF131D33);
    final blockBorder = Paint()
      ..color = const Color(0xFF1E2C4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final blockRects = [
      Rect.fromLTWH(size.width * 0.05, size.height * 0.10, size.width * 0.40, size.height * 0.22),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.08, size.width * 0.40, size.height * 0.20),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.42, size.width * 0.38, size.height * 0.35),
      Rect.fromLTWH(size.width * 0.52, size.height * 0.38, size.width * 0.42, size.height * 0.40),
    ];

    for (final b in blockRects) {
      canvas.drawRRect(RRect.fromRectAndRadius(b, const Radius.circular(8)), blockPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(b, const Radius.circular(8)), blockBorder);
    }

    // 3. Dark Grid Roads
    final roadPaint = Paint()
      ..color = const Color(0xFF18233C)
      ..strokeWidth = 22
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadCenterLine = Paint()
      ..color = const Color(0xFF243354)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final List<Path> roads = [
      Path()
        ..moveTo(0, size.height * 0.34)
        ..lineTo(size.width, size.height * 0.30),
      Path()
        ..moveTo(size.width * 0.48, 0)
        ..lineTo(size.width * 0.48, size.height),
      Path()
        ..moveTo(0, size.height * 0.78)
        ..lineTo(size.width, size.height * 0.80),
    ];

    for (final r in roads) {
      canvas.drawPath(r, roadPaint);
      canvas.drawPath(r, roadCenterLine);
    }

    // 4. Electric Blue Navigation Route
    final routePath = Path();
    routePath.moveTo(size.width * 0.48, size.height * 0.78);
    routePath.lineTo(size.width * 0.48, size.height * 0.50);
    routePath.lineTo(size.width * 0.65, size.height * 0.40);
    routePath.lineTo(size.width * 0.65, size.height * 0.18);
    routePath.lineTo(size.width * 0.82, size.height * 0.15);

    // Glowing Wide Path
    final routeGlow = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.35)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Solid Route Core
    final routeCore = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(routePath, routeGlow);
    canvas.drawPath(routePath, routeCore);

    // 5. Pickup Location Origin Marker (Glowing Concentric Rings)
    final pickupPos = Offset(size.width * 0.48, size.height * 0.78);
    final outerPulse = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pickupPos, 20, outerPulse);

    final midRing = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pickupPos, 12, midRing);

    final innerWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pickupPos, 6, innerWhite);

    // 6. Moving White 3D Vehicle Icon
    final metrics = routePath.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final metric = metrics.first;
      final dist = metric.length * progress;
      final tangent = metric.getTangentForOffset(dist);

      if (tangent != null) {
        final pos = tangent.position;

        // Shadow under car
        final carShadow = Paint()
          ..color = Colors.black87
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(pos + const Offset(0, 4), 16, carShadow);

        // White Car Body Pill
        final carBody = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: pos, width: 22, height: 32),
            const Radius.circular(8),
          ),
          carBody,
        );

        // Windshield / Roof Glass
        final carGlass = Paint()
          ..color = const Color(0xFF1E293B)
          ..style = PaintingStyle.fill;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: pos, width: 14, height: 16),
            const Radius.circular(4),
          ),
          carGlass,
        );

        // Taxi / Ride Top Roof Indicator
        final taxiIndicator = Paint()
          ..color = const Color(0xFF4F46E5)
          ..style = PaintingStyle.fill;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: pos, width: 8, height: 6),
            const Radius.circular(2),
          ),
          taxiIndicator,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _UberDarkMapPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
