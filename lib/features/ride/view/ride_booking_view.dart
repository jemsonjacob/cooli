import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/ride/view_model/ride_view_model.dart';
import 'package:cooli/features/ride/view/ride_selection_view.dart';
import 'package:cooli/utils/cooli_theme.dart';
import 'package:cooli/widgets/cooli_widgets.dart';

class RideBookingView extends StatefulWidget {
  static const String routeName = '/ride-booking';

  const RideBookingView({super.key});

  @override
  State<RideBookingView> createState() => _RideBookingViewState();
}

class _RideBookingViewState extends State<RideBookingView> {
  late RideViewModel _viewModel;
  final TextEditingController _dropController =
      TextEditingController(text: 'Cochin International Airport');

  @override
  void initState() {
    super.initState();
    _viewModel = RideViewModel();
  }

  @override
  void dispose() {
    _dropController.dispose();
    super.dispose();
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
            'Ride',
            style: TextStyle(
              color: CooliColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<RideViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                // Top Search Locations Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: CooliShadows.card,
                    border: Border.all(color: CooliColors.border),
                  ),
                  child: Column(
                    children: [
                      // Pickup Row
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CooliColors.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pickup Location',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: CooliColors.textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  vm.pickupLocation,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: CooliColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.my_location_rounded,
                              color: CooliColors.primary, size: 20),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 4, bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 2,
                              height: 20,
                              color: CooliColors.border,
                            ),
                          ],
                        ),
                      ),

                      // Drop Row
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CooliColors.danger,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Drop Location',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: CooliColors.textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextField(
                                  controller: _dropController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: CooliColors.textDark,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Where to?',
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: vm.setDrop,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.search_rounded,
                              color: CooliColors.textMuted, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),

                // Map View Visual Representation
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E9F2),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: CooliShadows.card,
                      border: Border.all(color: CooliColors.border),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Map grid / roads simulation
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _MapRoadsPainter(),
                          ),
                        ),

                        // Route Line & Pins
                        Positioned(
                          top: 80,
                          left: 60,
                          child: _buildLocationPin(
                            title: 'Pickup',
                            icon: Icons.person_pin_circle_rounded,
                            color: CooliColors.primary,
                          ),
                        ),

                        Positioned(
                          bottom: 110,
                          right: 70,
                          child: _buildLocationPin(
                            title: 'Airport',
                            icon: Icons.location_on_rounded,
                            color: CooliColors.danger,
                          ),
                        ),

                        // Moving Cab Marker on Route
                        Positioned(
                          top: 140,
                          left: 140,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: CooliShadows.button,
                            ),
                            child: const Icon(
                              Icons.directions_car_filled_rounded,
                              color: CooliColors.primary,
                              size: 24,
                            ),
                          ),
                        ),

                        // Quick Location Chips Bottom
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildQuickChip(Icons.home_rounded, 'Home'),
                              _buildQuickChip(Icons.work_rounded, 'Work'),
                              _buildQuickChip(Icons.history_rounded, 'Recent'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Search Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CooliButton(
                    text: 'Search Ride',
                    showForwardArrow: true,
                    onTap: () {
                      Navigator.pushNamed(context, RideSelectionView.routeName);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: CooliShadows.soft,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: CooliColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CooliColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPin({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: CooliShadows.soft,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
        Icon(icon, size: 34, color: color),
      ],
    );
  }
}

class _MapRoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final routePaint = Paint()
      ..color = CooliColors.primary.withValues(alpha: 0.8)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Background road curves
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.4), paint);
    canvas.drawLine(Offset(size.width * 0.2, 0), Offset(size.width * 0.8, size.height), paint);

    // Route curve
    final path = Path();
    path.moveTo(70, 110);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.4, size.width - 80, size.height - 120);
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
