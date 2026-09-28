import 'package:flutter/material.dart';

class RideOption {
  final String id;
  final String name;
  final String description;
  final double fare;
  final String eta;
  final IconData icon;

  const RideOption({
    required this.id,
    required this.name,
    required this.description,
    required this.fare,
    required this.eta,
    required this.icon,
  });
}

class DriverModel {
  final String name;
  final double rating;
  final String vehicleName;
  final String vehicleNumber;
  final String arrivingTime;
  final String photoUrl;

  const DriverModel({
    required this.name,
    required this.rating,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.arrivingTime,
    required this.photoUrl,
  });
}
