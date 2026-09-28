import 'package:cooli/features/onboarding/model/onboarding_model.dart';

class OnboardingRepo {
  List<OnboardingItem> getOnboardingItems() {
    return const [
      OnboardingItem(
        title: 'Everything You Need\nin One App',
        description: 'From eCommerce to delivery,\nrides, and more — all in one place.',
        imagePath: 'assets/images/cooli_courier_onboarding.jpg',
        badgeText: 'Verified & Fast',
      ),
      OnboardingItem(
        title: 'Quick & Reliable\nCity Rides',
        description: 'Book comfortable cabs and autos in seconds\nwith verified drivers and live tracking.',
        imagePath: 'assets/images/cooli_ride_carousel.jpg',
        badgeText: 'Instant Booking',
      ),
      OnboardingItem(
        title: 'Heavy Moving &\nGoods Delivery',
        description: 'Transport cargo, furniture shifting,\nand construction materials safely.',
        imagePath: 'assets/images/cooli_truck_splash.jpg',
        badgeText: 'Safe Logistics',
      ),
    ];
  }
}
