import 'package:flutter/material.dart';
import 'package:patients/utils/architecture.dart';

class SettingsRepository extends Repository {
  ThemeMode themeMode = ThemeMode.system;
  String clinicName = 'Adn Opd';

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

  void setClinicName(String value) {
    clinicName = value;
    notifyListeners();
  }
}
