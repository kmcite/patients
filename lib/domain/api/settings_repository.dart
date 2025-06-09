import 'package:patients/main.dart';

import '../models/settings.dart';

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
}
