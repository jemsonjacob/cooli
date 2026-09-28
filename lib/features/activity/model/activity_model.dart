import 'package:flutter/material.dart';

enum ActivityType { ecommerce, ride, porter, service }

class ActivityModel {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final double amount;
  final ActivityType type;
  final IconData icon;
  final Color statusColor;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.amount,
    required this.type,
    required this.icon,
    required this.statusColor,
  });
}
