import 'package:flutter/material.dart';
import 'package:cooli/features/services/model/service_model.dart';

class ServicesRepo {
  List<ServiceSubCategory> getSubCategories() {
    return const [
      ServiceSubCategory(id: 'cleaning', title: 'Cleaning', icon: Icons.cleaning_services_rounded),
      ServiceSubCategory(id: 'repair', title: 'Repair', icon: Icons.build_rounded),
      ServiceSubCategory(id: 'moving', title: 'Moving', icon: Icons.inventory_2_rounded),
      ServiceSubCategory(id: 'beauty', title: 'Beauty', icon: Icons.face_rounded),
      ServiceSubCategory(id: 'homeservices', title: 'Home Services', icon: Icons.home_repair_service_rounded),
      ServiceSubCategory(id: 'other', title: 'Other', icon: Icons.more_horiz_rounded),
    ];
  }

  List<HomeServiceModel> getHomeServices() {
    return const [
      HomeServiceModel(
        id: 'srv_cleaning',
        title: 'Home Cleaning',
        category: 'Cleaning',
        rating: 4.8,
        reviewCount: 250,
        startingPrice: 499.0,
        description: 'Professional deep home cleaning services for a cleaner, sanitized, and healthier home living space.',
        includedFeatures: [
          'Living Room Deep Cleaning & Mopping',
          'Bedroom Sanitization & Dusting',
          'Kitchen Countertop & Chimney Degreasing',
          'Bathroom Disinfection & Tile Scrubbing',
        ],
      ),
      HomeServiceModel(
        id: 'srv_ac_repair',
        title: 'AC Service & Repair',
        category: 'Repair',
        rating: 4.9,
        reviewCount: 180,
        startingPrice: 599.0,
        description: 'Complete air conditioner filter cleaning, gas refill check, and jet cooling service.',
        includedFeatures: [
          'Filter and Coil Washing',
          'Gas Pressure Leakage Inspection',
          'Drain Pipe Flushing',
        ],
      ),
    ];
  }
}
