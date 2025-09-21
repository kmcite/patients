import 'package:flutter/material.dart';
import 'package:patients/utils/architecture.dart';
import 'package:injectable/injectable.dart';

@singleton
class SettingsRepository extends Repository {
  ThemeMode themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode value) {
    themeMode = value;
    notifyListeners();
  }

  void toggleThemeMode() {
    switch (themeMode) {
      case ThemeMode.light:
        themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        themeMode = ThemeMode.light;
        break;
      case ThemeMode.system:
        themeMode = ThemeMode.light;
        break;
    }
    notifyListeners();
  }
}
