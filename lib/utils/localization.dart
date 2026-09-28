import 'package:cooli/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Localization {
  static late BuildContext _context;
  static BuildContext get context => _context;
  Localization.init(context) {
    _context = context;
  }
  static AppLocalizations get locale {
    return AppLocalizations.of(context)!;
  }
}
