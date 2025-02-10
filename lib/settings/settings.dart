import '../main.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

final settingsRM = RM.inject(
  () => const Settings(),
  // persist: () => persisted('settings', Settings.fromJson),
);
Settings settings([Settings? settings_]) {
  if (settings_ != null) settingsRM.state = settings_;
  return settingsRM.state;
}

double borderRadius([double? borderRadius]) {
  if (borderRadius != null) {
    settings(
      settings().copyWith(borderRadius: borderRadius),
    );
  }
  return settings().borderRadius;
}

MaterialColor materialColor([MaterialColor? materialColor]) {
  if (materialColor != null) {
    settings(
      settings().copyWith(materialColor: materialColor),
    );
  }
  return settings().materialColor;
}

double padding([double? padding]) {
  if (padding != null) {
    settings(
      settings().copyWith(padding: padding),
    );
  }
  return settings().padding;
}

ThemeMode themeMode([ThemeMode? themeMode]) {
  if (themeMode != null) {
    settings(
      settings().copyWith(themeMode: themeMode),
    );
  }
  return settings().themeMode;
}

@freezed
class Settings with _$Settings {
  const factory Settings({
    @Default(8.0) final double borderRadius,
    @Default(8.0) final double padding,
    @Default(ThemeMode.system) final ThemeMode themeMode,
    @MaterialColorConverter()
    @Default(Colors.brown)
    final MaterialColor materialColor,
  }) = _Settings;
  factory Settings.fromJson(json) => _$SettingsFromJson(json);
}
