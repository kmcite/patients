import 'package:flutter/material.dart';
import 'package:patients/_dermatosis/domain/models/settings.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final settingsRepository = SettingsRepository();

class SettingsRepository {
  late final settingsRM = RM.inject(
    () => Settings(),
  );

  Settings settings([Settings? settings]) {
    if (settings != null) {
      settingsRM
        ..state = settings
        ..notify();
    }
    return settingsRM.state;
  }

  String clinicName([String? value]) {
    if (value != null) settings(settings()..clinicName = value);
    return settings().clinicName;
  }

  ThemeMode themeMode([ThemeMode? themeMode]) {
    if (themeMode != null) {
      settings(
        settings()..themeModeIndex = ThemeMode.values.indexOf(themeMode),
      );
    }
    return ThemeMode.values[settings().themeModeIndex];
  }
}
