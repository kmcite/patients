import 'package:flutter/material.dart';

class Settings {
  int themeModeIndex = 0;
  String clinicName = '';

  ThemeMode get themeMode => ThemeMode.values[themeModeIndex];
  set themeMode(ThemeMode value) {
    themeModeIndex = ThemeMode.values.indexOf(value);
  }
}
