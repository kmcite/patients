import 'package:patients/main.dart';

class Settings {
  final ThemeMode themeMode;
  const Settings({
    this.themeMode = ThemeMode.system,
  });

  Settings copyWith({
    String? userName,
    ThemeMode? themeMode,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'themeMode': themeMode.index,
    };
    return jsonEncode(data);
  }

  factory Settings.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return Settings(
      themeMode: ThemeMode.values[data['themeMode'] ?? 0],
    );
  }
}
