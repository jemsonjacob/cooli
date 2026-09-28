import 'dart:async';



import 'package:cooli/l10n/app_localizations.dart';

import '/helpers/sp_helper.dart';
import '/utils/extensions.dart';
import '/utils/sp_keys.dart';

import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  static final LanguageProvider _instance = LanguageProvider._initialise();
  LanguageProvider._initialise() : super();
  factory LanguageProvider() => _instance;

  static BuildContext? _context;

  static void initContext(BuildContext context) {
    _context = context;
  }

  static AppLocalizations? get appLocalizations {
    if (_context == null) {
      throw Exception(
          "Context is not initialised. Please call AppLocalizationHelper.initContext(context) in builder method or within context.");
    }

    return AppLocalizations.of(_context!);
  }

  bool get isArabic => _locale.languageCode == "ar";
  bool get isEnglish => _locale.languageCode == "en";
  Locale _locale = const Locale("en", "US");
  Locale get locale => _locale;

  /// [languageList] is used to generate
  /// language list
  /// [languageList] contains Image,Name and language code
  ///
  List<LanguageModel> get languageList => [
        LanguageModel(
          image: 'language/en_logo.png'.asAssetImg(),
          name: "English",
          code: "en",
        ),
        LanguageModel(
          image: 'language/ar_logo.png'.asAssetImg(),
          name: "Arabic",
          code: "ar",
        ),
      ];

  set setLocale(Locale value) {
    _locale = value;
    _saveLanguagePreference(value.languageCode);
    notifyListeners();
  }

  Future<bool?> _saveLanguagePreference(String code) async {
    final sp = await SpHelper.getSP();
    return await sp.setString(keyLanguageCode, code);
  }

  /// Change the language to arabic
  void changeToAr() {
    setLocale = const Locale('ar');
    notifyListeners();
  }

  /// Change the language to english
  void changeToEn() {
    setLocale = const Locale('en');
    notifyListeners();
  }

  Future initAsync() async {
    try {
      final languageCode =
          await SpHelper.getSP().then((sp) => sp.getString(keyLanguageCode));
      switch (languageCode) {
        case 'en':
          changeToEn();
          notifyListeners();
          break;

        case 'ar':
          changeToAr();
          notifyListeners();
          break;
      }

      // ignore: empty_catches
    } catch (ex) {}
  }

  /// [getQuarterTurns] return quarterTurns
  /// for RotatedBox
  ///
  int get getQuarterTurns {
    if (isArabic) {
      return 2;
    }
    return 0;
  }
}

class LanguageModel {
  final String image;
  final String name;
  final String code;

  LanguageModel({
    required this.image,
    required this.name,
    required this.code,
  });
}
