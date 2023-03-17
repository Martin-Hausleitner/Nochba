import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en', 'US'),
    const Locale('de', 'DE'),
    const Locale('uk', 'UA'),
    const Locale('es', 'ES'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'de':
        return '🇩🇪';
      case 'uk':
        return '🇺🇦';
      case 'es':
        return '🇪🇸';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
