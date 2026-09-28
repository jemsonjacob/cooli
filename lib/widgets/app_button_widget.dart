import '/utils/colors.dart';
import '/utils/styles.dart';
import 'package:flutter/material.dart';

class AppButton extends _ThisAppButton {
  const AppButton({
    super.key,
    super.backgroundColor,
    super.textColor,
    required super.text,
    super.shadow,
    required super.onTap,
    super.textStyle,
    super.padding,
    super.height,
    super.prefixIcon,
    super.showBorder,
    super.borderRadius,
  });

  factory AppButton.curvedButton({
    final Color? backgroundColor,
    final Color? textColor,
    required String text,
    final BoxShadow? shadow,
    required GestureTapCallback onTap,
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final double? height,
    final Widget? prefixIcon,
    final bool? showBorder,
  }) {
    return AppButton(
      text: text,
      onTap: onTap,
      backgroundColor: backgroundColor,
      textColor: textColor,
      shadow: shadow,
      textStyle: textStyle,
      padding: padding,
      height: height,
      prefixIcon: prefixIcon,
      showBorder: showBorder,
      borderRadius: 44,
    );
  }
  factory AppButton.squareButton({
    final Color? backgroundColor,
    final Color? textColor,
    required String text,
    final BoxShadow? shadow,
    required GestureTapCallback onTap,
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final double? height,
    final Widget? prefixIcon,
    final bool? showBorder,
  }) {
    return AppButton(
      text: text,
      onTap: onTap,
      backgroundColor: backgroundColor,
      textColor: textColor,
      shadow: shadow,
      textStyle: textStyle,
      padding: padding,
      height: height,
      prefixIcon: prefixIcon,
      showBorder: showBorder,
      borderRadius: 0,
    );
  }
}

class _ThisAppButton extends StatelessWidget {
  const _ThisAppButton({
    super.key,
    this.backgroundColor,
    this.textColor,
    required this.text,
    this.shadow,
    required this.onTap,
    this.textStyle,
    this.padding,
    this.height,
    this.prefixIcon,
    this.showBorder,
    this.borderRadius,
  });

  final Color? backgroundColor;
  final Color? textColor;
  final String text;
  final BoxShadow? shadow;
  final GestureTapCallback onTap;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final double? height;
  final Widget? prefixIcon;
  final bool? showBorder;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRs = borderRadius != null
        ? BorderRadius.circular(borderRadius!)
        : BorderRadius.circular(10);

    BoxBorder? border;
    if (showBorder == true) {
      border = Border.all(color:AppColors(). colorInActiveBorder, width: 1);
    }

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        height: height ?? 56,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors().primaryButtonColor,
          borderRadius: borderRs,
          border: border,
          boxShadow: [shadow ?? const BoxShadow(color: Colors.transparent)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            prefixIcon != null
                ? Padding(
                    padding: EdgeInsetsDirectional.only(start: 12),
                    child: prefixIcon,
                  )
                : const SizedBox(),
            Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                text,
                style: textStyle ??
                    tsS17W700.copyWith(color: textColor ?? AppColors().colorWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
