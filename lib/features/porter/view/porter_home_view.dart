import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/porter/view_model/porter_view_model.dart';
import 'package:cooli/features/porter/view/book_porter_view.dart';
import 'package:cooli/features/porter/view/track_porter_view.dart';
import 'package:cooli/utils/cooli_theme.dart';

class PorterHomeView extends StatefulWidget {
  static const String routeName = '/porter-home';

  const PorterHomeView({super.key});

  @override
  State<PorterHomeView> createState() => _PorterHomeViewState();
}

class _PorterHomeViewState extends State<PorterHomeView> {
  late PorterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PorterViewModel();
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
            'Truck & Courier',
            style: TextStyle(
              color: CooliColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<PorterViewModel>(
          builder: (context, vm, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Hero Moving Banner Illustration
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B21A8), Color(0xFF9333EA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: CooliShadows.card,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_shipping_rounded,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Need to move something?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Mini trucks & tempos on demand for hassle-free shifting',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Option 1: Book Porter Card
                  _buildOptionCard(
                    title: 'Book Porter',
                    subtitle: 'Move items easily',
                    icon: Icons.local_shipping_rounded,
                    iconColor: const Color(0xFF9333EA),
                    bgColor: const Color(0xFFF5F3FF),
                    onTap: () {
                      Navigator.pushNamed(context, BookPorterView.routeName);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Option 2: My Bookings Card
                  _buildOptionCard(
                    title: 'My Bookings',
                    subtitle: 'View your requests',
                    icon: Icons.receipt_long_rounded,
                    iconColor: CooliColors.primary,
                    bgColor: CooliColors.primarySoft,
                    onTap: () {
                      Navigator.pushNamed(context, TrackPorterView.routeName);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: CooliShadows.card,
          border: Border.all(color: CooliColors.border.withValues(alpha: 0.8)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: CooliColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CooliColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: CooliColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
