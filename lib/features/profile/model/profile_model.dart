import 'package:flutter/material.dart';

class ProfileMenuItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String? badgeText;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.badgeText,
    this.onTap,
  });
}
