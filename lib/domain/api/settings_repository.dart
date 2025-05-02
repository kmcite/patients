import 'dart:async';

import 'package:patients/domain/models/settings.dart';
import 'package:patients/main.dart';

final settingsRepository = SettingsRepository();

class SettingsRepository {
  SettingsRepository() {
    controller.add(settings);
  }
  Stream<Settings> call() => controller.stream;
  final controller = StreamController<Settings>.broadcast();
  static const key = 'settings';
  Settings get settings => Settings.fromJson(prefs.getString(key) ?? '{}');

  void setSettings(Settings settings) {
    prefs.setString(key, settings.toJson());
    controller.add(settings);
  }

  /// THEME MODE
  ThemeMode get themeMode => settings.themeMode;

  void setThemeMode(ThemeMode? themeMode) {
    setSettings(settings.copyWith(themeMode: themeMode));
  }
}

class ThemeModeEvent extends Event {
  final ThemeMode themeMode;
  ThemeModeEvent(this.themeMode);
}

class ThemeModeToggledEvent extends Event {
  BuildContext context;
  ThemeModeToggledEvent(this.context);
}
