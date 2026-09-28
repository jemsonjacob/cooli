import 'package:cooli/utils/app_palette.dart';
import 'package:cooli/utils/brand_colors.dart';
import 'package:flutter/material.dart';

// Central seed color for the app's ColorScheme (brand primary blue)
const Color _seedColor = Color(0xFF2563EB);

// Shared corner radius
const double _radius = 12;

// Light Theme
final ThemeData appLightTheme = _buildTheme(
  brightness: Brightness.light,
);

// Dark Theme
final ThemeData appDarkTheme = _buildTheme(
  brightness: Brightness.dark,
);

ThemeData _buildTheme({required Brightness brightness}) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: brightness,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  return base.copyWith(
    extensions: <ThemeExtension<dynamic>>[
      AppBrandColors.fromScheme(colorScheme, isDark: isDark),
      // Brand palette tokens
      if (isDark) AppPalette.dark() else AppPalette.light(),
    ],
    // Prefer brand backgrounds in dark; keep default in light
    scaffoldBackgroundColor:
        isDark ? const Color(0xFF010413) : colorScheme.surface,

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      elevation: 1,
      indicatorColor: colorScheme.secondaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      surfaceTintColor: colorScheme.surfaceTint,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.primary,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      elevation: 1,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: base.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: colorScheme.surfaceContainerHighest
          .withValues(alpha: isDark ? 0.30 : 0.55),
      selectedColor: colorScheme.secondaryContainer,
      disabledColor:
          colorScheme.surfaceContainerHighest.withValues(alpha: 0.20),
      labelStyle: base.textTheme.labelLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      shape: StadiumBorder(
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      fillColor: Colors.transparent,
      hintStyle: base.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onSurfaceVariant,
      selectedTileColor: colorScheme.secondaryContainer,
      selectedColor: colorScheme.onSecondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: colorScheme.outline),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null; // default
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.outlineVariant;
      }),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: base.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      actionTextColor: colorScheme.tertiary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );
}

// Offline font switching:
// set to true after you bundle font assets in pubspec.yaml
const bool kUseBundledFonts = true;
const String kEnFontFamily = 'HostGrotesk';
const String kJaFontFamily = 'IBMPlexSansJP';

/// Returns a ThemeData whose textTheme is adjusted for the provided locale.
/// By default (kUseBundledFonts=false) we rely on platform fonts and fallbacks,
/// so this returns the theme unchanged. To enable custom bundled fonts, set
/// kUseBundledFonts=true and add the font families to pubspec.yaml.
ThemeData themedForLocale(ThemeData theme, Locale locale) {
  if (!kUseBundledFonts) return theme;

  final isJapanese = locale.languageCode.toLowerCase().startsWith('ja');
  final family = isJapanese ? kJaFontFamily : kEnFontFamily;

  TextStyle? withFamily(TextStyle? s) => s?.copyWith(fontFamily: family);

  TextTheme mapFamily(TextTheme t) => t.copyWith(
        displayLarge: withFamily(t.displayLarge),
        displayMedium: withFamily(t.displayMedium),
        displaySmall: withFamily(t.displaySmall),
        headlineLarge: withFamily(t.headlineLarge),
        headlineMedium: withFamily(t.headlineMedium),
        headlineSmall: withFamily(t.headlineSmall),
        titleLarge: withFamily(t.titleLarge),
        titleMedium: withFamily(t.titleMedium),
        titleSmall: withFamily(t.titleSmall),
        bodyLarge: withFamily(t.bodyLarge),
        bodyMedium: withFamily(t.bodyMedium),
        bodySmall: withFamily(t.bodySmall),
        labelLarge: withFamily(t.labelLarge),
        labelMedium: withFamily(t.labelMedium),
        labelSmall: withFamily(t.labelSmall),
      );

  return theme.copyWith(
    textTheme: mapFamily(theme.textTheme),
    primaryTextTheme: mapFamily(theme.primaryTextTheme),
  );
}
