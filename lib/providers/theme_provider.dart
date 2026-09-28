import 'package:adaptive_theme/adaptive_theme.dart';
import '../helpers/sp_helper.dart';
import '../utils/sp_keys.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _initFuture = _loadSavedTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;
  late final Future<void> _initFuture;

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(
    BuildContext context,
    ThemeMode mode, {
    bool force = false,
  }) async {
    if (!force && _themeMode == mode) return;
    _themeMode = mode;

    // Coordinate with AdaptiveTheme which provides the current ThemeData
    final controller = AdaptiveTheme.of(context);
    final sp = await SpHelper.getSP();
    
    switch (mode) {
      case ThemeMode.light:
        controller.setLight();
        await sp.setString(keyThemeMode, 'light');
        break;
      case ThemeMode.dark:
        controller.setDark();
        await sp.setString(keyThemeMode, 'dark');
        break;
      case ThemeMode.system:
        controller.setSystem();
        await sp.setString(keyThemeMode, 'system');
        break;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(BuildContext context) async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(context, ThemeMode.light);
    } else {
      await setThemeMode(context, ThemeMode.dark);
    }
  }

  Future<void> applySavedTheme(BuildContext context) async {
    await _initFuture;
    if (!context.mounted) return;
    await setThemeMode(context, _themeMode, force: true);
  }

  Future<void> _loadSavedTheme() async {
    final sp = await SpHelper.getSP();
    // Restore theme mode
    final savedMode = sp.getString(keyThemeMode);
    if (savedMode != null) {
      switch (savedMode) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
          _themeMode = ThemeMode.system;
          break;
      }
    } else {
      _themeMode = ThemeMode.dark;
    }

    notifyListeners();
  }
}
