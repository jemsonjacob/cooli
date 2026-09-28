import 'package:flutter/material.dart';
import 'package:cooli/features/porter/model/porter_model.dart';

class PorterRepo {
  List<PorterVehicleType> getVehicleTypes() {
    return const [
      PorterVehicleType(
        id: '3wheeler',
        name: '3-Wheeler',
        capacity: '500 kg',
        basePrice: 280.0,
        icon: Icons.electric_rickshaw_rounded,
      ),
      PorterVehicleType(
        id: 'tata_ace',
        name: 'Tata Ace',
        capacity: '750 kg',
        basePrice: 450.0,
        icon: Icons.local_shipping_rounded,
      ),
      PorterVehicleType(
        id: '8ft_pickup',
        name: '8ft Pickup',
        capacity: '1200 kg',
        basePrice: 700.0,
        icon: Icons.airport_shuttle_rounded,
      ),
    ];
  }

  PorterBookingModel getSampleBooking() {
    return const PorterBookingModel(
      id: 'PT1234',
      vehicleType: 'Tata Ace',
      pickupAddress: 'Vyttila, Kochi',
      dropAddress: 'Kakkanad, Kochi',
      itemsDescription: 'Furniture, appliances etc.',
      dateTime: 'Today, 11:00 AM',
      estimatedPrice: 450.0,
      status: 'Pickup in Progress',
      estimatedArrival: 'Today, 12:30 PM',
    );
  }
}
