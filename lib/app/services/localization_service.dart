import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class SupportedLanguage {
  const SupportedLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
    this.isFullyTranslated = false,
  });

  final String code;
  final String nativeName;
  final String englishName;
  final bool isFullyTranslated;

  Locale get locale => Locale(code);
}

class LocalizationService {
  LocalizationService._();

  static const Locale fallbackLocale = Locale('ar');
  static const String translationsPath = 'assets/translations';

  static const supportedLanguages = [
    SupportedLanguage(
      code: 'ar',
      nativeName: 'العربية',
      englishName: 'Arabic',
      isFullyTranslated: true,
    ),
    SupportedLanguage(
      code: 'en',
      nativeName: 'English',
      englishName: 'English',
      isFullyTranslated: true,
    ),
    SupportedLanguage(
      code: 'fr',
      nativeName: 'Français',
      englishName: 'French',
    ),
    SupportedLanguage(
      code: 'zh',
      nativeName: '中文',
      englishName: 'Chinese',
    ),
    SupportedLanguage(
      code: 'ja',
      nativeName: '日本語',
      englishName: 'Japanese',
    ),
    SupportedLanguage(
      code: 'hi',
      nativeName: 'हिन्दी',
      englishName: 'Hindi',
    ),
    SupportedLanguage(
      code: 'de',
      nativeName: 'Deutsch',
      englishName: 'German',
    ),
    SupportedLanguage(
      code: 'pt',
      nativeName: 'Português',
      englishName: 'Portuguese',
    ),
    SupportedLanguage(
      code: 'ru',
      nativeName: 'Русский',
      englishName: 'Russian',
    ),
  ];

  static List<Locale> get supportedLocales =>
      supportedLanguages.map((language) => language.locale).toList();

  static SupportedLanguage languageFromCode(String code) {
    return supportedLanguages.firstWhere(
      (language) => language.code == code,
      orElse: () => supportedLanguages.first,
    );
  }

  static bool get isRtl =>
      WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'ar';

  static String t(String key, {Map<String, String>? namedArgs}) {
    return easy.tr(key, namedArgs: namedArgs);
  }

  static Locale currentLocale(BuildContext context) {
    return easy.BuildContextEasyLocalizationExtension(context).locale;
  }

  static Future<void> setLocale(BuildContext context, Locale locale) {
    return easy.BuildContextEasyLocalizationExtension(context)
        .setLocale(locale);
  }

  static List<LocalizationsDelegate<dynamic>> delegates(BuildContext context) {
    return easy.BuildContextEasyLocalizationExtension(context)
        .localizationDelegates;
  }

  static List<Locale> contextSupportedLocales(BuildContext context) {
    return easy.BuildContextEasyLocalizationExtension(context).supportedLocales;
  }
}
