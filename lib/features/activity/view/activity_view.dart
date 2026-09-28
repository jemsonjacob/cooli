import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooli/features/activity/model/activity_model.dart';
import 'package:cooli/features/activity/view_model/activity_view_model.dart';
import 'package:cooli/utils/cooli_theme.dart';

class ActivityView extends StatefulWidget {
  static const String routeName = '/activity';

  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  late ActivityViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ActivityViewModel();
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
          title: const Text(
            'Activity & Orders',
            style: TextStyle(
              color: CooliColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<ActivityViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                // Filter Chips Row
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', null, vm),
                        _buildFilterChip('E-Commerce', ActivityType.ecommerce, vm),
                        _buildFilterChip('Rides', ActivityType.ride, vm),
                        _buildFilterChip('Porter', ActivityType.porter, vm),
                        _buildFilterChip('Services', ActivityType.service, vm),
                      ],
                    ),
                  ),
                ),

                // Activity List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.activities.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final act = vm.activities[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: CooliShadows.card,
                          border: Border.all(color: CooliColors.border.withValues(alpha: 0.8)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: CooliColors.primarySoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(act.icon, color: CooliColors.primary, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          act.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: CooliColors.textDark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '₹${act.amount.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: CooliColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    act.subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: CooliColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        act.date,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: CooliColors.textLight,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: act.statusColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          act.status,
                                          style: TextStyle(
                                            color: act.statusColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, ActivityType? type, ActivityViewModel vm) {
    final isSelected = vm.selectedFilter == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => vm.setFilter(type),
        selectedColor: CooliColors.primary,
        backgroundColor: CooliColors.surfaceAlt,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : CooliColors.textDark,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? CooliColors.primary : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
