import 'package:patients/domain/models/settings.dart';
import 'package:patients/main.dart';
import 'package:patients/main_hmis.dart';

final SettingsRepository settingsRepository = SettingsRepository();

class SettingsRepository extends Service {
  static const key = 'settings';
  Settings get settings => Settings.fromJson(prefs.getString(key) ?? '{}');

  void setSettings(Settings settings) {
    prefs.setString(key, settings.toJson());
  }

  /// THEME MODE
  ThemeMode get themeMode => settings.themeMode;

  void setThemeMode(ThemeMode? themeMode) {
    setSettings(settings.copyWith(themeMode: themeMode));
  }

  /// USER NAME
  String get userName => settings.userName;
  void setUserName(String? value) {
    setSettings(settings.copyWith(userName: value));
  }

  @override
  void handle(Event event) {
    if (event is ThemeModeEvent) {
      setThemeMode(event.themeMode);
    } else if (event is ThemeModeToggledEvent) {
      if (themeMode == ThemeMode.system) {
        setThemeMode(
          MediaQuery.of(event.context).platformBrightness == Brightness.dark
              ? ThemeMode.light
              : ThemeMode.dark,
        );
      } else {
        setThemeMode(
          themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
        );
      }
    } else if (event is UserNameChangedEvent) {
      setUserName(event.userName);
    }
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

class UserNameChangedEvent extends Event {
  final String userName;
  UserNameChangedEvent(this.userName);
}
