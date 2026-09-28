import 'package:cooli/config/app_config.dart';
import 'package:flutter/services.dart';

import '/providers/language_provider.dart';
import '/utils/colors.dart';
import '/utils/extensions.dart';
import '/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final TextStyle? textStyle;
  final bool? ishideBackButton;
  final EdgeInsetsDirectional? padding;
  final List<Widget>? trailing;
  const CustomAppBar({
    super.key,
    this.title,
    this.textStyle,
    this.onTap,
    this.ishideBackButton = false,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsetsDirectional.zero,
      child: Row(children: [
        Visibility(
          visible: !ishideBackButton!,
          child: Container(
            height: 38,
            width: 38,
            margin: EdgeInsetsDirectional.only(end: 13),
            decoration: BoxDecoration(
              color: AppColors().colorE8EFFF,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onTap,
              icon: Consumer<LanguageProvider>(
                builder: (context, provider, child) {
                  return RotatedBox(
                    quarterTurns: provider.getQuarterTurns,
                    child: SvgPicture.asset(
                      'ic_arrow_left_bold'.asAssetSvg(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title ?? "",
                maxLines: 2,
                style: textStyle ??
                    tsS22W600.copyWith(
                      color: AppColors().primaryButtonColor,
                    ),
              ),
              Row(
                children: trailing != null ? trailing! : [],
              )
            ],
          ),
        ),
      ]),
    );
  }
}

AppBar buildAppBar(
    {required String title,
    VoidCallback? onBackPress,
    bool? showActions,
    bool? showBack = true}) {
  return AppBar(
    automaticallyImplyLeading: true,
    flexibleSpace: SizedBox(
      width: 250,
      height: 250,
    ),
    title: Text(
      title,
      style: tsS16W600.copyWith(color: AppColors().colorBlack),
      textAlign: TextAlign.start,
    ),
    leading: showBack!
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors().colorBlack,
            ),
            onPressed: () {
              if (onBackPress != null) {
                onBackPress();
              } else {
                Navigator.of(AppConfig.navKey.currentState!.context).pop();
              }
            },
          )
        : null,
    actions: showActions == null
        ? []
        : [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SvgPicture.asset('ic_logout'.asAssetSvg()),
            ),
          ],
    titleSpacing: showBack ? 0 : 10,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors().colorBlack),
    backgroundColor: AppColors().colorWhite,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors().colorWhite,
      // <-- SEE HERE
      statusBarIconBrightness: Brightness.light,
      //<-- For Android SEE HERE (dark icons)
      statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
    ),
  );
}
