import 'package:flutter/material.dart';

class LocaleNotifier extends ValueNotifier<Locale> {
  static final LocaleNotifier instance = LocaleNotifier._();
  LocaleNotifier._() : super(const Locale('en'));

  static const Map<String, Locale> _localeMap = {
    'English': Locale('en'),
    'Urdu': Locale('ur'),
    'en': Locale('en'),
    'ur': Locale('ur'),
  };

  void setFromPreference(String langPref) {
    final next = _localeMap[langPref] ?? const Locale('en');
    if (value != next) {
      value = next;
    }
  }

  Locale get current => value;
  bool get isRTL => value.languageCode == 'ur';
}
