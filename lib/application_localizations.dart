import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationLocalizations {
  final String appLocale;

  ApplicationLocalizations(this.appLocale);

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static ApplicationLocalizations? of(BuildContext context) {
    return Localizations.of<ApplicationLocalizations>(
        context, ApplicationLocalizations);
  }

  static Map<String, String> _localizedStrings = {};

  static Future<ApplicationLocalizations> load(Locale locale) async {
    // Load JSON file from the "language" folder
    String jsonString = await rootBundle
        .loadString('resources/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonLanguageMap = json.decode(jsonString);
    _localizedStrings = jsonLanguageMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return ApplicationLocalizations(locale.languageCode);
  }

// called from every widget which needs a localized text
  String? translate(String jsonkey) {    
    return _localizedStrings[jsonkey];
  }

  // Getter para acceder al locale
  String get locale => this.appLocale;
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<ApplicationLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('en', 'US'),
      Locale('es', 'ES'),
    ];
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  @override
  bool isSupported(Locale locale) {
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
      return false;
  }

  @override
  Future<ApplicationLocalizations> load(Locale locale) =>
      ApplicationLocalizations.load(locale);
}
