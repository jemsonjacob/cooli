import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/ecommerce/view_model/ecommerce_view_model.dart';
import 'package:cooli/utils/cooli_theme.dart';

class TrackOrderView extends StatefulWidget {
  static const String routeName = '/track-order';

  const TrackOrderView({super.key});

  @override
  State<TrackOrderView> createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  late EcommerceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EcommerceViewModel();
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
          title: Column(
            children: const [
              Text(
                'Track Order',
                style: TextStyle(
                  color: CooliColors.textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Order #CO12345',
                style: TextStyle(
                  color: CooliColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Consumer<EcommerceViewModel>(
          builder: (context, vm, child) {
            final order = vm.currentOrder;
            if (order == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: CooliShadows.card,
                        border: Border.all(color: CooliColors.border),
                      ),
                      child: ListView.builder(
                        itemCount: order.steps.length,
                        itemBuilder: (context, index) {
                          final step = order.steps[index];
                          final isLast = index == order.steps.length - 1;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: step.isCompleted
                                          ? CooliColors.success
                                          : step.isCurrent
                                              ? CooliColors.primary
                                              : CooliColors.surfaceAlt,
                                      border: Border.all(
                                        color: step.isCompleted
                                            ? CooliColors.success
                                            : step.isCurrent
                                                ? CooliColors.primary
                                                : CooliColors.border,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: step.isCompleted
                                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 2,
                                      height: 50,
                                      color: step.isCompleted
                                          ? CooliColors.success
                                          : CooliColors.border,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.title,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: step.isCompleted || step.isCurrent
                                            ? CooliColors.textDark
                                            : CooliColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      step.time,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CooliColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Estimated Delivery Card
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
                            Icons.access_time_filled_rounded,
                            color: CooliColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Estimated Delivery',
                              style: TextStyle(
                                fontSize: 12,
                                color: CooliColors.textMuted,
                              ),
                            ),
                            Text(
                              order.estimatedDelivery,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: CooliColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
