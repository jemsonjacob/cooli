import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/services/model/service_model.dart';
import 'package:cooli/features/services/view_model/services_view_model.dart';
import 'package:cooli/features/services/view/book_service_view.dart';
import 'package:cooli/utils/cooli_theme.dart';
import 'package:cooli/widgets/cooli_widgets.dart';

class ServiceDetailView extends StatefulWidget {
  static const String routeName = '/service-detail';
  final HomeServiceModel? service;

  const ServiceDetailView({super.key, this.service});

  @override
  State<ServiceDetailView> createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends State<ServiceDetailView> {
  late ServicesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ServicesViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service ?? _viewModel.selectedService ?? _viewModel.services.first;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Custom Top App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: CooliColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: CooliColors.textDark,
                        ),
                      ),
                    ),
                    const Text(
                      'Service Details',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: CooliColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Large Graphic Banner
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.cleaning_services_rounded,
                                size: 80,
                                color: Color(0xFF0284C7),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Verified Experts • 100% Satisfaction',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0369A1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Title
                      Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: CooliColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Rating & Price Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${service.rating}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${service.reviewCount}+ reviews)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CooliColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Text(
                        '₹${service.startingPrice.toStringAsFixed(0)} onwards',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: CooliColors.primary,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        service.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CooliColors.textMuted,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // What's Included Section
                      const Text(
                        "What's Included",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: CooliColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...service.includedFeatures.map(
                        (feat) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: CooliColors.successSoft,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: CooliColors.success,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feat,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: CooliColors.textDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Book Now Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CooliButton(
                  text: 'Book Now',
                  onTap: () {
                    Navigator.pushNamed(context, BookServiceView.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
