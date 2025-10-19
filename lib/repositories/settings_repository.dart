import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/utils/services/persistence_config.dart';
import 'package:patients/utils/services/repository.dart';
import 'package:patients/utils/services/serializer/enum_serializer.dart';
import 'package:patients/utils/services/hive.dart';

@singleton
class SettingsRepository extends Repository<ThemeMode> {
  SettingsRepository()
      : super(
          persistence: PersistenceConfig(
            key: 'themeMode',
            storage: HiveStorage(),
            serializer: EnumSerializer<ThemeMode>(
              (i) {
                return ThemeMode.values[i ?? 0];
              },
            ),
          ),
        );
  @override
  ThemeMode get initialState => ThemeMode.system;

  void toggleThemeMode() {
    switch (value) {
      case ThemeMode.light:
        update(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        update(ThemeMode.light);
        break;
      case ThemeMode.system:
        update(ThemeMode.light);
        break;
    }
  }

  @override
  @disposeMethod
  FutureOr dispose() async {
    super.dispose();
  }
}
