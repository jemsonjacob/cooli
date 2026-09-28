import 'package:flutter/material.dart';

/// App brand palette as a ThemeExtension so it participates in theming
// ignore: unintended_html_in_doc_comment
/// and can be accessed via Theme.of(context).extension<AppPalette>().
///
/// Source (provided):
/// - Primary Blue: #2563EB
/// - Accent Blue:  #2A3EB5
/// - Backgrounds:  Pure Black #000000, Deep Navy #010413, Dark Navy #030A22,
///                 Medium Navy #0A163D
/// - Text:         White #FFFFFF, Off White #ECEDF1,
///                 Light Gray #BDC3D9, Medium Gray #A5ACC2, Subtle Gray #7B809D
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primaryBlue,
    required this.accentBlue,
    required this.bgPureBlack,
    required this.bgDeepNavy,
    required this.bgDarkNavy,
    required this.bgMediumNavy,
    required this.textWhite,
    required this.textOffWhite,
    required this.textLightGray,
    required this.textMediumGray,
    required this.textSubtleGray,
  });

  // For light, we keep the same brand hues for primary/accent, but default
  // to lighter backgrounds. Consumers should still rely on ColorScheme for
  // surfaces; this palette provides brand constants when needed.
  factory AppPalette.light() => const AppPalette(
        primaryBlue: Color(0xFF2563EB),
        accentBlue: Color(0xFF2A3EB5),
        bgPureBlack:
            Color(0xFFFFFFFF), // use white in light as the base bg token
        bgDeepNavy:
            Color(0xFFF6F7FB), // soft light surface analogous to deep navy
        bgDarkNavy: Color(0xFFEFF2F8),
        bgMediumNavy: Color(0xFFE7ECF7),
        textWhite: Color(0xFF0B0B0B), // flip for readability in light
        textOffWhite: Color(0xFF111316),
        textLightGray: Color(0xFF465169),
        textMediumGray: Color(0xFF5A6887),
        textSubtleGray: Color(0xFF7B809D),
      ); // #7B809D

  factory AppPalette.dark() => const AppPalette(
        primaryBlue: Color(0xFF2563EB),
        accentBlue: Color(0xFF2A3EB5),
        bgPureBlack: Color(0xFF000000),
        bgDeepNavy: Color(0xFF010413),
        bgDarkNavy: Color(0xFF030A22),
        bgMediumNavy: Color(0xFF0A163D),
        textWhite: Color(0xFFFFFFFF),
        textOffWhite: Color(0xFFECEDF1),
        textLightGray: Color(0xFFBDC3D9),
        textMediumGray: Color(0xFFA5ACC2),
        textSubtleGray: Color(0xFF7B809D),
      );

  final Color primaryBlue; // #2563EB
  final Color accentBlue; // #2A3EB5

  // Backgrounds
  final Color bgPureBlack; // #000000
  final Color bgDeepNavy; // #010413
  final Color bgDarkNavy; // #030A22
  final Color bgMediumNavy; // #0A163D

  // Text
  final Color textWhite; // #FFFFFF
  final Color textOffWhite; // #ECEDF1
  final Color textLightGray; // #BDC3D9
  final Color textMediumGray; // #A5ACC2
  final Color textSubtleGray;

  @override
  AppPalette copyWith({
    Color? primaryBlue,
    Color? accentBlue,
    Color? bgPureBlack,
    Color? bgDeepNavy,
    Color? bgDarkNavy,
    Color? bgMediumNavy,
    Color? textWhite,
    Color? textOffWhite,
    Color? textLightGray,
    Color? textMediumGray,
    Color? textSubtleGray,
  }) {
    return AppPalette(
      primaryBlue: primaryBlue ?? this.primaryBlue,
      accentBlue: accentBlue ?? this.accentBlue,
      bgPureBlack: bgPureBlack ?? this.bgPureBlack,
      bgDeepNavy: bgDeepNavy ?? this.bgDeepNavy,
      bgDarkNavy: bgDarkNavy ?? this.bgDarkNavy,
      bgMediumNavy: bgMediumNavy ?? this.bgMediumNavy,
      textWhite: textWhite ?? this.textWhite,
      textOffWhite: textOffWhite ?? this.textOffWhite,
      textLightGray: textLightGray ?? this.textLightGray,
      textMediumGray: textMediumGray ?? this.textMediumGray,
      textSubtleGray: textSubtleGray ?? this.textSubtleGray,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      bgPureBlack: Color.lerp(bgPureBlack, other.bgPureBlack, t)!,
      bgDeepNavy: Color.lerp(bgDeepNavy, other.bgDeepNavy, t)!,
      bgDarkNavy: Color.lerp(bgDarkNavy, other.bgDarkNavy, t)!,
      bgMediumNavy: Color.lerp(bgMediumNavy, other.bgMediumNavy, t)!,
      textWhite: Color.lerp(textWhite, other.textWhite, t)!,
      textOffWhite: Color.lerp(textOffWhite, other.textOffWhite, t)!,
      textLightGray: Color.lerp(textLightGray, other.textLightGray, t)!,
      textMediumGray: Color.lerp(textMediumGray, other.textMediumGray, t)!,
      textSubtleGray: Color.lerp(textSubtleGray, other.textSubtleGray, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
