import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/ride/view_model/ride_view_model.dart';
import 'package:cooli/features/dashboard/view/main_navigation_view.dart';

class RideCompletedView extends StatefulWidget {
  static const String routeName = '/ride-completed';

  const RideCompletedView({super.key});

  @override
  State<RideCompletedView> createState() => _RideCompletedViewState();
}

class _RideCompletedViewState extends State<RideCompletedView> {
  late RideViewModel _viewModel;
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    _viewModel = RideViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                MainNavigationView.routeName,
                (route) => false,
              );
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),

                // Top Checkmark + 3D Car Illustration on Soft Cloud
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Cloud / Glow background
                    Container(
                      width: 220,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFEEF2FF),
                            const Color(0xFFE0E7FF).withValues(alpha: 0.5),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          radius: 0.8,
                        ),
                      ),
                    ),

                    // 3D Realistic Car
                    SizedBox(
                      height: 120,
                      child: Image.asset(
                        'assets/images/dash_ride_car_clean.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.directions_car_filled_rounded,
                          size: 80,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),

                    // Floating Top Blue Checkmark Badge
                    Positioned(
                      top: -10,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // "Ride Completed!" Title
                const Text(
                  'Ride Completed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Fare Amount
                const Text(
                  '₹250',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 4),

                // Payment Method Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Paid via UPI',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.sync_rounded,
                      size: 16,
                      color: Color(0xFF4F46E5),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // "How was your ride?"
                const Text(
                  'How was your ride?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),

                const SizedBox(height: 14),

                // 5 Interactive Rating Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starVal = index + 1;
                    final isSelected = starVal <= _selectedRating;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRating = starVal;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Icon(
                          isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 36,
                          color: isSelected ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                        ),
                      ),
                    );
                  }),
                ),

                const Spacer(flex: 2),

                // Submit Rating Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thank you for your feedback!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        MainNavigationView.routeName,
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      shadowColor: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                    ),
                    child: const Text(
                      'Submit Rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Done Button (Soft outline/pill)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        MainNavigationView.routeName,
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
