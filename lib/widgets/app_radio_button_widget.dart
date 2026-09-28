import '/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppRadioButtonWidget extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;
  const AppRadioButtonWidget({
    required this.value,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
    Widget? child;
    if (value) {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF3C3F4E)),
        color: const Color(0xFF3C3F4E),
      );
      child = SvgPicture.asset(
        'tick-white'.asAssetSvg(),
        fit: BoxFit.contain,
      );
    } else {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD0D0D0)),
      );
    }
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 26,
        height: 26,
        decoration: decoration,
        padding: EdgeInsets.all(3),
        child: child,
      ),
    );
  }
}
