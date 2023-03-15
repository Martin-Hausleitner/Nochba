
import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en', 'US'),
    const Locale('de', 'DE'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'de':
        return '🇩🇪';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}