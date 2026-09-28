import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String route;

  const ServiceCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.route,
  });
}

class RecentActivityItem {
  final String id;
  final String title;
  final String status;
  final String time;
  final IconData icon;
  final Color iconColor;
  final double amount;

  const RecentActivityItem({
    required this.id,
    required this.title,
    required this.status,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.amount,
  });
}
