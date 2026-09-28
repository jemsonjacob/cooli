import 'package:flutter/material.dart';
import 'package:cooli/utils/enums.dart';

class AppConfig {
  static const appName = "Cooli";
  static const bundleId = "com.cooli.app";
  static const designWidth = 375;
  static const designHeight = 812;

  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  GlobalKey bottomNavigationKey = GlobalKey();
  static bool isDebugMode = true;

  static EnumBuildEnvironment server = EnumBuildEnvironment.dg;
}
