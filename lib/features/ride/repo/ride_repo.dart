import 'package:flutter/material.dart';
import 'package:cooli/features/ride/model/ride_model.dart';

class RideRepo {
  List<RideOption> getRideOptions() {
    return const [
      RideOption(
        id: 'opt_economy',
        name: 'Economy',
        description: 'Affordable, everyday rides',
        fare: 160.0,
        eta: '4 min away',
        icon: Icons.local_taxi_rounded,
      ),
      RideOption(
        id: 'opt_comfort',
        name: 'Comfort',
        description: 'Newer cars with extra legroom',
        fare: 250.0,
        eta: '6 min away',
        icon: Icons.directions_car_filled_rounded,
      ),
      RideOption(
        id: 'opt_premium',
        name: 'Premium',
        description: 'Top rated drivers & luxury sedans',
        fare: 400.0,
        eta: '8 min away',
        icon: Icons.airport_shuttle_rounded,
      ),
    ];
  }

  DriverModel getAssignedDriver() {
    return const DriverModel(
      name: 'Rahul Kumar',
      rating: 4.9,
      vehicleName: 'Toyota Etios',
      vehicleNumber: 'KL 07 AB 1234',
      arrivingTime: '4 min',
      photoUrl: '',
    );
  }
}
