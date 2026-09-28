import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/porter/view_model/porter_view_model.dart';
import 'package:cooli/utils/cooli_theme.dart';

class TrackPorterView extends StatefulWidget {
  static const String routeName = '/track-porter';

  const TrackPorterView({super.key});

  @override
  State<TrackPorterView> createState() => _TrackPorterViewState();
}

class _TrackPorterViewState extends State<TrackPorterView> {
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
          title: Column(
            children: const [
              Text(
                'Track Booking',
                style: TextStyle(
                  color: CooliColors.textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Booking #PT1234',
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
        body: Consumer<PorterViewModel>(
          builder: (context, vm, child) {
            final steps = [
              {'title': 'Booking Confirmed', 'time': '12 Apr, 11:00 AM', 'done': true},
              {'title': 'Pickup in Progress', 'time': '12 Apr, 11:45 AM', 'done': true},
              {'title': 'On the Way', 'time': 'Expected 12:15 PM', 'done': false},
              {'title': 'Delivered', 'time': 'Expected 12:30 PM', 'done': false},
            ];

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
                        itemCount: steps.length,
                        itemBuilder: (context, index) {
                          final step = steps[index];
                          final isDone = step['done'] as bool;
                          final isLast = index == steps.length - 1;

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
                                      color: isDone ? CooliColors.success : CooliColors.surfaceAlt,
                                      border: Border.all(
                                        color: isDone ? CooliColors.success : CooliColors.border,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: isDone
                                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 2,
                                      height: 60,
                                      color: isDone ? CooliColors.success : CooliColors.border,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step['title'] as String,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isDone ? CooliColors.textDark : CooliColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      step['time'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CooliColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 36),
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

                  // Estimated Arrival Card
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
                          children: const [
                            Text(
                              'Estimated Arrival',
                              style: TextStyle(
                                fontSize: 12,
                                color: CooliColors.textMuted,
                              ),
                            ),
                            Text(
                              'Today, 12:30 PM',
                              style: TextStyle(
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
