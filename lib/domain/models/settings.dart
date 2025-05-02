import 'package:patients/main.dart';

class Settings {
  final String userName;
  final ThemeMode themeMode;
  const Settings({
    this.userName = '',
    this.themeMode = ThemeMode.system,
  });

  Settings copyWith({
    String? userName,
    ThemeMode? themeMode,
  }) {
    return Settings(
      userName: userName ?? this.userName,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  String toJson() {
    final Map<String, dynamic> data = {
      'userName': userName,
      'themeMode': themeMode.index,
    };
    return jsonEncode(data);
  }

  factory Settings.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return Settings(
      userName: data['userName'] ?? '',
      themeMode: ThemeMode.values[data['themeMode'] ?? 0],
    );
  }
}
