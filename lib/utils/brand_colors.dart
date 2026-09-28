import 'package:flutter/material.dart';

class AppBrandColors extends ThemeExtension<AppBrandColors> {
  const AppBrandColors({
    // semantic tokens (existing)
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.danger,
    required this.onDanger,
    required this.color293250,
    required this.color49516C,
    required this.neutralBg,
    required this.neutralFg,
    required this.primarySoft,
    required this.onPrimarySoft,
    required this.accent,
    required this.onAccent,

    // brand palette tokens (new)
    required this.primaryBlue,
    required this.accentBlue,
    required this.lightBlue,
    required this.bgPureBlack,
    required this.bgDeepNavy,
    required this.bgDarkNavy,
    required this.bgMediumNavy,
    required this.textWhite,
    required this.textOffWhite,
    required this.textLightGray,
    required this.textMediumGray,
    required this.textSubtleGray,
    required this.amberGold,
    required this.accentBlue2,
    required this.accentBlue3,
    required this.tuna,
    required this.darkSlateBlue,
    required this.slateGray,
    required this.bgExtraDarkNavy,
    required this.deepNavy,
    required this.sheetBlue,
    required this.sheetLightBlue,
    required this.maastrichtBlue,
    required this.englishVermillion,
    required this.guideNavBarColor,
    required this.textColor,
    required this.toolTipBg,
    required this.dialogHeaderBg,
    required this.dialogBodyBg,
    required this.progressBarBg,
    required this.progressColor,
    required this.color414E77WithDynamic,
    required this.unread,
  });

  factory AppBrandColors.fromScheme(ColorScheme s, {required bool isDark}) {
    // Semantic tokens; tweak to your brand as needed
    const success = Color(0xFF0B7F33);
    final onSuccess = isDark ? const Color(0xFF08170E) : Colors.white;

    const warning = Color(0xFFFFA000);
    final onWarning = isDark ? const Color(0xFF1F1403) : Colors.white;

    const unread = Color(0xFFEAB308);

    final danger = isDark
        ? Color.fromARGB(255, 255, 45, 55)
        : Color.fromARGB(255, 255, 106, 6);
    final onDanger = isDark ? const Color(0xFF210306) : Colors.white;
    final color293250 =
        isDark ? const Color(0xFF293250) : const Color(0xFFD1D5E0);

    final color49516C =
        isDark ? const Color(0xFF49516C) : const Color(0xFF49516C);

    final guideNavBarColor = isDark
        ? const Color(0xFF293250)
        : const Color(0xFF2563EB).withValues(alpha: .1);

    final textColor = isDark ? Colors.white : Colors.black;

    final toolTipBg = isDark ? const Color(0xFF1F2E63) : Colors.white;
    final dialogHeaderBg = isDark ? const Color(0xFF293250) : Colors.white;
    final dialogBodyBg = isDark ? const Color(0xFF49516C) : Colors.white;

    final progressBarBg =
        isDark ? const Color(0xFF0A163D) : const Color(0xFFE3E5EF);

    final progressColor =
        isDark ? const Color(0xFFE3E5EF) : const Color(0xFF0A163D);

    final color414E77WithDynamic = isDark
        ? const Color(0xFF414E77)
        : const Color.fromARGB(255, 220, 223, 231);

    // Brand palette tokens from design spec
    const primaryBlue = Color(0xFF2563EB);
    const lightBlue = Color(0xFF32A6F9);
    const accentBlue = Color(0xFF121D44);
    const bgPureBlack = Color(0xFF000000);
    const bgDeepNavy = Color(0xFF010413);

    const bgMediumNavy = Color(0xFF0A163D);
    const textWhite = Color(0xFFFFFFFF);
    const textOffWhite = Color(0xFFECEDF1);
    const textLightGray = Color(0xFFBDC3D9);
    const textMediumGray = Color(0xFFA5ACC2);
    const textSubtleGray = Color(0xFF7B809D);
    const amberGold = Color(0xFFFFCB45);
    const accentBlue2 = Color(0xFF2D38C8);
    const accentBlue3 = Color(0xFF2A4BCE);
    const tuna = Color(0xFF2C334D);
    const darkSlateBlue = Color(0xFF39446A);
    const slateGray = Color(0xFF7B808D);
    const bgExtraDarkNavy = Color(0xFF010617);
    const deepNavy = Color(0xFF202F65);
    const sheetBlue = Color(0xFF010617);
    const sheetLightBlue = Color(0xFF1B2138);
    const maastrichtBlue = Color(0xFF091639);
    const englishVermillion = Color(0xFFCE463D);
    return AppBrandColors(
      unread: unread,
      success: success,
      onSuccess: onSuccess,
      warning: warning,
      onWarning: onWarning,
      danger: danger,
      onDanger: onDanger,
      color293250: color293250,
      color49516C: color49516C,
      neutralBg: s.surfaceContainerHighest,
      neutralFg: s.onSurfaceVariant,
      primarySoft: s.primaryContainer,
      onPrimarySoft: s.onPrimaryContainer,
      accent: s.secondaryContainer,
      onAccent: s.onSecondaryContainer,
      // palette
      primaryBlue: primaryBlue,
      lightBlue: lightBlue,
      accentBlue: accentBlue,
      bgPureBlack: bgPureBlack,
      bgDeepNavy: bgDeepNavy,
      bgDarkNavy: const Color(0xFF030A22),
      bgMediumNavy: bgMediumNavy,
      textWhite: textWhite,
      textOffWhite: textOffWhite,
      textLightGray: textLightGray,
      textMediumGray: textMediumGray,
      textSubtleGray: textSubtleGray,
      amberGold: amberGold,
      accentBlue2: accentBlue2,
      accentBlue3: accentBlue3,
      tuna: tuna,
      darkSlateBlue: darkSlateBlue,
      slateGray: slateGray,
      bgExtraDarkNavy: bgExtraDarkNavy,
      deepNavy: deepNavy,
      sheetBlue: sheetBlue,
      sheetLightBlue: sheetLightBlue,
      maastrichtBlue: maastrichtBlue,
      englishVermillion: englishVermillion,
      guideNavBarColor: guideNavBarColor,
      textColor: textColor,
      toolTipBg: toolTipBg,
      dialogHeaderBg: dialogHeaderBg,
      dialogBodyBg: dialogBodyBg,
      progressBarBg: progressBarBg,
      progressColor: progressColor,
      color414E77WithDynamic: color414E77WithDynamic,
    );
  }
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color unread;

  final Color danger;
  final Color onDanger;
  final Color color293250;
  final Color color49516C;

  final Color neutralBg;
  final Color neutralFg;

  final Color primarySoft;
  final Color onPrimarySoft;

  final Color accent;
  final Color onAccent;

  final Color guideNavBarColor;
  final Color textColor;
  final Color toolTipBg;
  final Color dialogHeaderBg;
  final Color dialogBodyBg;
  final Color progressBarBg;
  final Color progressColor;
  final Color color414E77WithDynamic;

  // Brand palette tokens
  final Color primaryBlue; // #2563EB
  final Color accentBlue; // #2A3EB5
  final Color lightBlue; // #32A6F9
  final Color bgPureBlack; // #000000
  final Color bgDeepNavy; // #010413
  final Color bgDarkNavy; // #030A22
  final Color bgMediumNavy; // #0A163D
  final Color textWhite; // #FFFFFF
  final Color textOffWhite; // #ECEDF1
  final Color textLightGray; // #BDC3D9
  final Color textMediumGray; // #A5ACC2
  final Color textSubtleGray; // #7B809D
  final Color amberGold; // #FFCB45
  final Color accentBlue2; // #2D38C8
  final Color accentBlue3; // #2A4BCE
  final Color tuna; // #2C334D
  final Color darkSlateBlue; // #39446A
  final Color slateGray; // #7B808D
  final Color bgExtraDarkNavy; // #010617
  final Color deepNavy; // #202F65
  final Color sheetBlue; // #010617
  final Color sheetLightBlue; // #1B2138
  final Color maastrichtBlue; // #091639
  final Color englishVermillion; // #CE463D

  @override
  AppBrandColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? unread,
    Color? onWarning,
    Color? info,
    Color? onInfo,
    Color? danger,
    Color? onDanger,
    Color? neutralBg,
    Color? neutralFg,
    Color? primarySoft,
    Color? onPrimarySoft,
    Color? accent,
    Color? onAccent,
    Color? primaryBlue,
    Color? accentBlue,
    Color? lightBlue,
    Color? bgPureBlack,
    Color? bgDeepNavy,
    Color? bgDarkNavy,
    Color? bgMediumNavy,
    Color? textWhite,
    Color? textOffWhite,
    Color? textLightGray,
    Color? textMediumGray,
    Color? textSubtleGray,
    Color? amberGold,
    Color? accentBlue2,
    Color? accentBlue3,
    Color? color293250,
    Color? color49516C,
    Color? tuna,
    Color? darkSlateBlue,
    Color? slateGray,
    Color? bgExtraDarkNavy,
    Color? deepNavy,
    Color? sheetBlue,
    Color? sheetLightBlue,
    Color? maastrichtBlue,
    Color? englishVermillion,
    Color? guideNavBarColor,
    Color? textColor,
    Color? toolTipBg,
    Color? progressBarBg,
    Color? dialogBodyBg,
    Color? dialogHeaderBg,
    Color? progressColor,
    Color? color414E77WithDynamic,
  }) {
    return AppBrandColors(
      unread: unread ?? this.unread,
      dialogHeaderBg: dialogHeaderBg ?? this.dialogHeaderBg,
      dialogBodyBg: dialogBodyBg ?? this.dialogBodyBg,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      color293250: color293250 ?? this.color293250,
      color49516C: color49516C ?? this.color49516C,
      neutralBg: neutralBg ?? this.neutralBg,
      neutralFg: neutralFg ?? this.neutralFg,
      primarySoft: primarySoft ?? this.primarySoft,
      onPrimarySoft: onPrimarySoft ?? this.onPrimarySoft,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      primaryBlue: primaryBlue ?? this.primaryBlue,
      accentBlue: accentBlue ?? this.accentBlue,
      lightBlue: lightBlue ?? this.lightBlue,
      bgPureBlack: bgPureBlack ?? this.bgPureBlack,
      bgDeepNavy: bgDeepNavy ?? this.bgDeepNavy,
      bgDarkNavy: bgDarkNavy ?? this.bgDarkNavy,
      bgMediumNavy: bgMediumNavy ?? this.bgMediumNavy,
      textWhite: textWhite ?? this.textWhite,
      textOffWhite: textOffWhite ?? this.textOffWhite,
      textLightGray: textLightGray ?? this.textLightGray,
      textMediumGray: textMediumGray ?? this.textMediumGray,
      textSubtleGray: textSubtleGray ?? this.textSubtleGray,
      amberGold: amberGold ?? this.amberGold,
      accentBlue2: accentBlue2 ?? this.accentBlue2,
      accentBlue3: accentBlue3 ?? this.accentBlue3,
      tuna: tuna ?? this.tuna,
      darkSlateBlue: darkSlateBlue ?? this.darkSlateBlue,
      slateGray: slateGray ?? this.slateGray,
      bgExtraDarkNavy: bgExtraDarkNavy ?? this.bgExtraDarkNavy,
      deepNavy: deepNavy ?? this.deepNavy,
      sheetBlue: sheetBlue ?? this.sheetBlue,
      sheetLightBlue: sheetLightBlue ?? this.sheetLightBlue,
      maastrichtBlue: maastrichtBlue ?? this.maastrichtBlue,
      englishVermillion: englishVermillion ?? this.englishVermillion,
      guideNavBarColor: guideNavBarColor ?? this.guideNavBarColor,
      textColor: textColor ?? this.textColor,
      toolTipBg: toolTipBg ?? this.toolTipBg,
      progressBarBg: progressBarBg ?? this.progressBarBg,
      progressColor: progressColor ?? this.progressColor,
      color414E77WithDynamic:
          color414E77WithDynamic ?? this.color414E77WithDynamic,
    );
  }

  @override
  AppBrandColors lerp(ThemeExtension<AppBrandColors>? other, double t) {
    if (other is! AppBrandColors) return this;
    return AppBrandColors(
      unread: Color.lerp(unread, other.unread, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      color293250: Color.lerp(color293250, other.color293250, t)!,
      color49516C: Color.lerp(color49516C, other.color49516C, t)!,
      neutralBg: Color.lerp(neutralBg, other.neutralBg, t)!,
      neutralFg: Color.lerp(neutralFg, other.neutralFg, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      onPrimarySoft: Color.lerp(onPrimarySoft, other.onPrimarySoft, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      lightBlue: Color.lerp(lightBlue, other.lightBlue, t)!,
      bgPureBlack: Color.lerp(bgPureBlack, other.bgPureBlack, t)!,
      bgDeepNavy: Color.lerp(bgDeepNavy, other.bgDeepNavy, t)!,
      bgDarkNavy: Color.lerp(bgDarkNavy, other.bgDarkNavy, t)!,
      bgMediumNavy: Color.lerp(bgMediumNavy, other.bgMediumNavy, t)!,
      textWhite: Color.lerp(textWhite, other.textWhite, t)!,
      textOffWhite: Color.lerp(textOffWhite, other.textOffWhite, t)!,
      textLightGray: Color.lerp(textLightGray, other.textLightGray, t)!,
      textMediumGray: Color.lerp(textMediumGray, other.textMediumGray, t)!,
      textSubtleGray: Color.lerp(textSubtleGray, other.textSubtleGray, t)!,
      amberGold: Color.lerp(amberGold, other.amberGold, t)!,
      accentBlue2: Color.lerp(accentBlue2, other.accentBlue2, t)!,
      accentBlue3: Color.lerp(accentBlue3, other.accentBlue3, t)!,
      tuna: Color.lerp(tuna, other.tuna, t)!,
      darkSlateBlue: Color.lerp(darkSlateBlue, other.darkSlateBlue, t)!,
      slateGray: Color.lerp(slateGray, other.slateGray, t)!,
      bgExtraDarkNavy: Color.lerp(bgExtraDarkNavy, other.bgExtraDarkNavy, t)!,
      deepNavy: Color.lerp(deepNavy, other.deepNavy, t)!,
      sheetBlue: Color.lerp(sheetBlue, other.sheetBlue, t)!,
      sheetLightBlue: Color.lerp(sheetLightBlue, other.sheetLightBlue, t)!,
      maastrichtBlue: Color.lerp(maastrichtBlue, other.maastrichtBlue, t)!,
      englishVermillion:
          Color.lerp(englishVermillion, other.englishVermillion, t)!,
      guideNavBarColor:
          Color.lerp(guideNavBarColor, other.guideNavBarColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      toolTipBg: Color.lerp(toolTipBg, other.toolTipBg, t)!,
      dialogHeaderBg: Color.lerp(dialogHeaderBg, other.dialogHeaderBg, t)!,
      dialogBodyBg: Color.lerp(dialogBodyBg, other.dialogBodyBg, t)!,
      progressBarBg: Color.lerp(progressBarBg, other.progressBarBg, t)!,
      progressColor: Color.lerp(progressColor, other.progressColor, t)!,
      color414E77WithDynamic:
          Color.lerp(color414E77WithDynamic, other.color414E77WithDynamic, t)!,
    );
  }
}

extension AppBrandColorsContext on BuildContext {
  AppBrandColors get brand => Theme.of(this).extension<AppBrandColors>()!;
}
