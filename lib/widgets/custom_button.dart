import '/utils/colors.dart';
import '/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final bool isDarkColour;
  final double borderRadius;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isDarkColour = false,
    this.borderRadius = 9,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 37, right: 37, top: 14, bottom: 14),
        decoration: BoxDecoration(
          color: isDarkColour ? AppColors().color373A4B : AppColors().colorWhite,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(width: 1, color: AppColors().colorEBEBEB),
        ),
        child: Text(
          text ?? "",
          style: tsS17W700.copyWith(
              color: isDarkColour ?AppColors(). colorWhite : AppColors().color373A4B),
        ),
      ),
    );
  }
}
