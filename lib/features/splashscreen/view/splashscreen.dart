import 'dart:async';

import 'package:cooli/features/splashscreen/view_model/splash_view_model.dart';
import 'package:cooli/providers/language_provider.dart';
import 'package:cooli/providers/theme_provider.dart';
import 'package:cooli/utils/brand_colors.dart';
import 'package:cooli/utils/styles.dart';
import 'package:cooli/widgets/app_button_widget.dart';
import 'package:cooli/widgets/app_custom_text_field.dart';
import 'package:cooli/widgets/app_progress_widget.dart';
import 'package:cooli/widgets/app_radio_button_widget.dart';
import 'package:cooli/widgets/custom_app_bar.dart';
import 'package:cooli/widgets/custom_checkbox_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  TextEditingController textEditingController = TextEditingController();
  late SplashViewModel _splashViewModel;
  late LanguageProvider _languageProvider;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      //Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
    _splashViewModel = SplashViewModel();

    _languageProvider = LanguageProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().applySavedTheme(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the current color scheme for theming
    final cs = Theme.of(context).colorScheme;
    // Access the brand colors for consistent theming (Custom pallette defined in utils/brand_colors.dart)
    final brand = context.brand;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _splashViewModel),
        ChangeNotifierProvider.value(value: _languageProvider),
      ],
      child: Scaffold(
        appBar: buildAppBar(title: "Test Screen", showActions: true),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AppButton",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25, left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton.curvedButton(
                            text: "Save",
                            onTap: () {},
                            backgroundColor: Colors.blueGrey),
                        AppButton(
                          text: "Save",
                          onTap: () {},
                          backgroundColor: Colors.blueGrey,
                        ),
                        AppButton.squareButton(
                          text: "Save",
                          onTap: () {},
                          backgroundColor: Colors.blueGrey,
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 12),
                    child: Text(
                      "Theme",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, provider, child) {
                      final isDark = provider.themeMode == ThemeMode.dark;
                      return SwitchListTile(
                        value: isDark,
                        onChanged: (value) {
                          provider.setThemeMode(
                            context,
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                        title: const Text("Dark mode"),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                  // Example container to show theme change and usage of color scheme
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: cs
                          .onSurfaceVariant, // Using color from the current theme's color scheme
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Column(
                        children: [
                          Text(
                            "Themed Container using color scheme",
                            style: TextStyle(color: brand.accent, fontSize: 16),
                          ),
                          //should restart app to see theme change effect on this text as it uses a custom color
                          // from brand colors which changes based on theme
                          Text(
                            "Eg 2: Custom brand color for both themes",
                            style: TextStyle(color: brand.danger, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "This text color changes",
                            style: TextStyle(color: cs.onPrimary, fontSize: 18),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // you can check dark or light like-
                  Text(
                    "Current Theme: ${context.watch<ThemeProvider>().themeMode == ThemeMode.dark ? "Dark" : "Light"}",
                    style: TextStyle(
                        fontSize: 16,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "or Like this isDark : ${cs.brightness == Brightness.dark}",
                    style: TextStyle(
                        fontSize: 16,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      "Check Box",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Consumer<SplashViewModel>(
                    builder: (context, provider, child) => CustomCheckBoxWidget(
                        value: provider.checkBoxVal ?? false,
                        onTap: () {
                          provider.checkBoxVal == true
                              ? provider.checkBoxVal = false
                              : provider.checkBoxVal = true;
                        }),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 20),
                    child: Text(
                      "Text Field",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  CustomTextField(
                    hint: "search",
                    controller: textEditingController,
                    hintStyle: tsS14W400,
                    textStyle: tsS14W400,
                    prefixWidget: Icon(
                      Icons.search,
                      size: 25,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 22),
                    child: Text(
                      "Radio Button",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Consumer<SplashViewModel>(
                      builder: (context, provider, child) => Row(
                            children: [
                              AppRadioButtonWidget(
                                value: provider.checkRadioButtonVal ?? false,
                                onTap: () {
                                  provider.checkRadioButtonVal == true
                                      ? provider.checkRadioButtonVal = false
                                      : provider.checkRadioButtonVal = true;
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              provider.checkRadioButtonVal == false
                                  ? const Text(
                                      "Click button",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : const Text(
                                      "Item 1",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.green),
                                    )
                            ],
                          )),
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 22),
                    child: Text(
                      "Progress Widget",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const AppProgressWidget(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
