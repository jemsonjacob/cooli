import 'package:flutter/material.dart';
import 'package:cooli/features/dashboard/view/home_view.dart';

class MainNavigationView extends StatelessWidget {
  static const String routeName = '/main-navigation';

  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}
