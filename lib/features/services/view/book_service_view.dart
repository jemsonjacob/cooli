import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/services/view_model/services_view_model.dart';
import 'package:cooli/features/services/view/service_confirmed_view.dart';
import 'package:cooli/utils/cooli_theme.dart';
import 'package:cooli/widgets/cooli_widgets.dart';

class BookServiceView extends StatefulWidget {
  static const String routeName = '/book-service';

  const BookServiceView({super.key});

  @override
  State<BookServiceView> createState() => _BookServiceViewState();
}

class _BookServiceViewState extends State<BookServiceView> {
  late ServicesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ServicesViewModel();
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
            'Book Service',
            style: TextStyle(
              color: CooliColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<ServicesViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Select Date
                        _buildSectionHeader('Select Date'),
                        const SizedBox(height: 8),
                        _buildPickerCard(
                          icon: Icons.calendar_today_rounded,
                          title: vm.selectedDate,
                          onTap: () {},
                        ),

                        const SizedBox(height: 20),

                        // Select Time
                        _buildSectionHeader('Select Time'),
                        const SizedBox(height: 8),
                        _buildPickerCard(
                          icon: Icons.access_time_rounded,
                          title: vm.selectedTime,
                          onTap: () {},
                        ),

                        const SizedBox(height: 20),

                        // Address
                        _buildSectionHeader('Address'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: CooliShadows.card,
                            border: Border.all(color: CooliColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CooliColors.primarySoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: CooliColors.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Home',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: CooliColors.textDark,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Kochi, Kerala',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: CooliColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    color: CooliColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom Action & Total Price
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: CooliShadows.elevated,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Total Price',
                            style: TextStyle(fontSize: 12, color: CooliColors.textMuted),
                          ),
                          Text(
                            '₹499',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: CooliColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: CooliButton(
                          text: 'Confirm Booking',
                          onTap: () {
                            Navigator.pushNamed(context, ServiceConfirmedView.routeName);
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: CooliColors.textDark,
      ),
    );
  }

  Widget _buildPickerCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CooliShadows.card,
        border: Border.all(color: CooliColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: CooliColors.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CooliColors.textDark,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: CooliColors.textMuted,
          ),
        ],
      ),
    );
  }
}
