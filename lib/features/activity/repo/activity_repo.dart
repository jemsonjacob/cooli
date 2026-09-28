import 'package:flutter/material.dart';
import 'package:cooli/features/activity/model/activity_model.dart';
import 'package:cooli/utils/cooli_theme.dart';

class ActivityRepo {
  List<ActivityModel> getAllActivities() {
    return const [
      ActivityModel(
        id: 'CO12345',
        title: 'River Sand & Red Bricks',
        subtitle: 'Delivered to Kochi, Kerala',
        date: 'Today, 10:24 AM',
        status: 'In Transit',
        amount: 11150.0,
        type: ActivityType.ecommerce,
        icon: Icons.inventory_2_rounded,
        statusColor: CooliColors.warning,
      ),
      ActivityModel(
        id: 'RD9876',
        title: 'Airport Ride (Comfort Sedan)',
        subtitle: 'Kaloor -> Cochin International Airport',
        date: 'Yesterday, 04:30 PM',
        status: 'Completed',
        amount: 250.0,
        type: ActivityType.ride,
        icon: Icons.directions_car_filled_rounded,
        statusColor: CooliColors.success,
      ),
      ActivityModel(
        id: 'PT1234',
        title: 'Tata Ace Porter Booking',
        subtitle: 'House shifting 4 items',
        date: '12 Apr, 11:00 AM',
        status: 'Pickup in Progress',
        amount: 450.0,
        type: ActivityType.porter,
        icon: Icons.local_shipping_rounded,
        statusColor: CooliColors.info,
      ),
      ActivityModel(
        id: 'BK1234',
        title: 'Home Deep Cleaning',
        subtitle: '3 BHK Full Cleaning Service',
        date: '10 Apr, 10:00 AM',
        status: 'Completed',
        amount: 499.0,
        type: ActivityType.service,
        icon: Icons.cleaning_services_rounded,
        statusColor: CooliColors.success,
      ),
    ];
  }
}
