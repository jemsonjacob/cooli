import 'package:flutter/material.dart';

class ServiceSubCategory {
  final String id;
  final String title;
  final IconData icon;

  const ServiceSubCategory({
    required this.id,
    required this.title,
    required this.icon,
  });
}

class HomeServiceModel {
  final String id;
  final String title;
  final String category;
  final double rating;
  final int reviewCount;
  final double startingPrice;
  final String description;
  final List<String> includedFeatures;

  const HomeServiceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.startingPrice,
    required this.description,
    required this.includedFeatures,
  });
}
