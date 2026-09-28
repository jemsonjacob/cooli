import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cooli/config/app_config.dart';
import 'package:cooli/l10n/app_localizations.dart';

import 'package:cooli/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/interceptors.dart';
import 'utils/localization.dart';
import 'utils/routes.dart';
import 'utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
      ],
      builder: (context, child) => ScreenUtilInit(
        designSize: Size(
          AppConfig.designWidth.toDouble(),
          AppConfig.designHeight.toDouble(),
        ),
        builder: (context, child) => AdaptiveTheme(
          initial: AdaptiveThemeMode.light,
          light: appLightTheme,
          dark: appDarkTheme,
          builder: (theme, darkTheme) {
            return MaterialApp(
              navigatorKey: AppConfig.navKey,
              title: AppConfig.appName,
              themeMode: context.watch<ThemeProvider>().themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
                Locale('ja', ''),
              ],
              theme: themedForLocale(
                theme,
                context.watch<LanguageProvider>().locale,
              ),
              darkTheme: themedForLocale(
                darkTheme,
                context.watch<LanguageProvider>().locale,
              ),
              locale: context.watch<LanguageProvider>().locale,

              initialRoute: '/',
              onGenerateRoute: onAppGenerateRoute(),
              routes: appRoutes(),
              builder: (context, child) {
                LanguageProvider.initContext(context);
                Localization.init(context);

                if (kDebugMode) {
                  StackTrace.current.toString().log('', true);
                  child = AppStackInterceptorBuilder(child: child!);
                }
                return child!;
              },
            );
          },
        ),
      ),
    );
  }
}
