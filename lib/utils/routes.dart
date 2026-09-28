import 'package:flutter/material.dart';
import 'package:cooli/features/splash/view/splash_view.dart';
import 'package:cooli/features/onboarding/view/onboarding_view.dart';
import 'package:cooli/features/auth/view/login_view.dart';
import 'package:cooli/features/auth/view/register_view.dart';
import 'package:cooli/features/auth/view/otp_verification_view.dart';
import 'package:cooli/features/dashboard/view/main_navigation_view.dart';
import 'package:cooli/features/ecommerce/view/ecommerce_home_view.dart';
import 'package:cooli/features/ecommerce/view/product_detail_view.dart';
import 'package:cooli/features/ecommerce/view/cart_view.dart';
import 'package:cooli/features/ecommerce/view/checkout_view.dart';
import 'package:cooli/features/ecommerce/view/order_confirmed_view.dart';
import 'package:cooli/features/ecommerce/view/track_order_view.dart';
import 'package:cooli/features/ride/view/ride_booking_view.dart';
import 'package:cooli/features/ride/view/ride_selection_view.dart';
import 'package:cooli/features/ride/view/ride_tracking_view.dart';
import 'package:cooli/features/ride/view/ride_completed_view.dart';
import 'package:cooli/features/porter/view/porter_home_view.dart';
import 'package:cooli/features/porter/view/book_porter_view.dart';
import 'package:cooli/features/porter/view/track_porter_view.dart';
import 'package:cooli/features/services/view/services_home_view.dart';
import 'package:cooli/features/services/view/service_detail_view.dart';
import 'package:cooli/features/services/view/book_service_view.dart';
import 'package:cooli/features/services/view/service_confirmed_view.dart';
import 'package:cooli/features/profile/view/profile_view.dart';
import 'package:cooli/features/activity/view/activity_view.dart';
import 'package:cooli/features/ecommerce/model/product_model.dart';
import 'package:cooli/features/services/model/service_model.dart';

Map<String, Widget Function(BuildContext context)> appRoutes() => {
      '/': (context) => const SplashView(),
      SplashView.routeName: (context) => const SplashView(),
      OnboardingView.routeName: (context) => const OnboardingView(),
      LoginView.routeName: (context) => const LoginView(),
      RegisterView.routeName: (context) => const RegisterView(),
      OtpVerificationView.routeName: (context) => const OtpVerificationView(),
      MainNavigationView.routeName: (context) => const MainNavigationView(),
      EcommerceHomeView.routeName: (context) => const EcommerceHomeView(),
      CartView.routeName: (context) => const CartView(),
      CheckoutView.routeName: (context) => const CheckoutView(),
      OrderConfirmedView.routeName: (context) => const OrderConfirmedView(),
      TrackOrderView.routeName: (context) => const TrackOrderView(),
      RideBookingView.routeName: (context) => const RideBookingView(),
      RideSelectionView.routeName: (context) => const RideSelectionView(),
      RideTrackingView.routeName: (context) => const RideTrackingView(),
      RideCompletedView.routeName: (context) => const RideCompletedView(),
      PorterHomeView.routeName: (context) => const PorterHomeView(),
      BookPorterView.routeName: (context) => const BookPorterView(),
      TrackPorterView.routeName: (context) => const TrackPorterView(),
      ServicesHomeView.routeName: (context) => const ServicesHomeView(),
      BookServiceView.routeName: (context) => const BookServiceView(),
      ServiceConfirmedView.routeName: (context) => const ServiceConfirmedView(),
      ProfileView.routeName: (context) => const ProfileView(),
      ActivityView.routeName: (context) => const ActivityView(),
    };

Widget? _getScreen(RouteSettings settings) {
  switch (settings.name) {
    case ProductDetailView.routeName:
      final product = settings.arguments as ProductModel?;
      return ProductDetailView(product: product);
    case ServiceDetailView.routeName:
      final service = settings.arguments as HomeServiceModel?;
      return ServiceDetailView(service: service);
    default:
      return null;
  }
}

RouteFactory onAppGenerateRoute() => (settings) {
      Widget? screen = _getScreen(settings);
      if (screen != null) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (_, a, __, c) {
            return FadeTransition(opacity: a, child: c);
          },
        );
      }
      return null;
    };
