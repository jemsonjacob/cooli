import 'package:flutter/material.dart';

class PorterVehicleType {
  final String id;
  final String name;
  final String capacity;
  final double basePrice;
  final IconData icon;

  const PorterVehicleType({
    required this.id,
    required this.name,
    required this.capacity,
    required this.basePrice,
    required this.icon,
  });
}

class PorterBookingModel {
  final String id;
  final String vehicleType;
  final String pickupAddress;
  final String dropAddress;
  final String itemsDescription;
  final String dateTime;
  final double estimatedPrice;
  final String status;
  final String estimatedArrival;

  const PorterBookingModel({
    required this.id,
    required this.vehicleType,
    required this.pickupAddress,
    required this.dropAddress,
    required this.itemsDescription,
    required this.dateTime,
    required this.estimatedPrice,
    required this.status,
    required this.estimatedArrival,
  });
}
