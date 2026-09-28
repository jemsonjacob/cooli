import 'package:flutter/material.dart';
import 'package:cooli/features/dashboard/model/dashboard_model.dart';
import 'package:cooli/features/ecommerce/view/ecommerce_home_view.dart';
import 'package:cooli/features/ride/view/ride_booking_view.dart';
import 'package:cooli/features/porter/view/porter_home_view.dart';
import 'package:cooli/features/services/view/services_home_view.dart';

class DashboardRepo {
  List<ServiceCategory> getServiceCategories() {
    return const [
      ServiceCategory(
        id: 'ecommerce',
        title: 'E-Commerce',
        subtitle: 'Sand & Bricks',
        icon: Icons.view_in_ar_rounded,
        color: Color(0xFFFF6B00),
        bgColor: Color(0xFFFFF3EB),
        route: EcommerceHomeView.routeName,
      ),
      ServiceCategory(
        id: 'ride',
        title: 'Rides',
        subtitle: 'Cabs & Auto',
        icon: Icons.directions_car_filled_rounded,
        color: Color(0xFF16A34A),
        bgColor: Color(0xFFF0FDF4),
        route: RideBookingView.routeName,
      ),
      ServiceCategory(
        id: 'porter',
        title: 'Truck & Courier',
        subtitle: 'Mini-Trucks & Cargo',
        icon: Icons.local_shipping_rounded,
        color: Color(0xFF2563EB),
        bgColor: Color(0xFFEFF6FF),
        route: PorterHomeView.routeName,
      ),
      ServiceCategory(
        id: 'services',
        title: 'Home Services',
        subtitle: 'Cleaning & Repairs',
        icon: Icons.handyman_rounded,
        color: Color(0xFF0D9488),
        bgColor: Color(0xFFF0FDFA),
        route: ServicesHomeView.routeName,
      ),
    ];
  }

  List<RecentActivityItem> getRecentActivities() {
    return const [
      RecentActivityItem(
        id: 'S1234',
        title: 'Sand Order #S1234',
        status: 'Completed',
        time: '2h ago',
        icon: Icons.inventory_2_rounded,
        iconColor: Color(0xFFFF6B00),
        amount: 1200.0,
      ),
      RecentActivityItem(
        id: 'RD890',
        title: 'Ride to Airport',
        status: 'Completed',
        time: '4h ago',
        icon: Icons.directions_car_filled_rounded,
        iconColor: Color(0xFF2563EB),
        amount: 250.0,
      ),
    ];
  }
}
