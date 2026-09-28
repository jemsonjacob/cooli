import '/utils/colors.dart';
import 'package:flutter/material.dart';

class AppCustomScrollBar extends RawScrollbar {
  AppCustomScrollBar({
    super.key,
    double? thickness,
    bool? interactive,
    Radius? radius,
    bool? thumbVisibility,
    bool? trackVisibility,
    Color? trackColor,
    Color? thumbColor,
    super.controller,
    required super.child,
  }) : super(
          interactive: interactive ?? true,
          radius: radius ?? Radius.circular(10),
          thumbVisibility: thumbVisibility ?? true,
          trackVisibility: trackVisibility ?? true,
          trackColor: trackColor ??  AppColors().colorF5F5F5,
          thumbColor: thumbColor ??  AppColors().primaryButtonColor,
          trackRadius: radius ?? Radius.circular(100),
          trackBorderColor: Colors.transparent,
        );
}
