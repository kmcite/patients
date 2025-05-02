import 'package:forui/theme.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';

export 'dart:convert';
export 'dart:io';
export 'objectbox.g.dart';
export 'package:colornames/colornames.dart';
export 'package:flutter/material.dart' hide Action;
export 'package:flutter_native_splash/flutter_native_splash.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:manager/manager.dart';
export 'package:objectbox/objectbox.dart';
export 'package:path_provider/path_provider.dart';
export 'package:patients/domain/models/user.dart';
export 'package:patients/ui/user_ui.dart';
export 'package:patients/ui/home_page.dart';
export 'package:patients/domain/api/duty_hours_calculator.dart';
export 'package:patients/domain/api/roster_manager.dart';
export 'package:patients/ui/roster_page.dart';
export 'package:patients/ui/roster_table.dart';
export 'package:patients/ui/table_cell_builder.dart';
export 'package:patients/ui/upcoming_duties.dart';
export 'package:patients/domain/api/upcoming_duty_finder.dart';
export 'package:patients/domain/api/dark_repository.dart';
export 'package:patients/ui/settings_page.dart';
export 'package:states_rebuilder/scr/state_management/common/logger.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
export 'package:uuid/uuid.dart';
export 'ui/patients/patients_page.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  manager(PatientsApp(), openStore: openStore);
}

mixin class _App {
  Modifier<bool> get dark => darkRepository.dark;
}

class PatientsApp extends UI with _App {
  PatientsApp({super.key});
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, child) => FTheme(
        data: dark() ? FThemes.orange.dark : FThemes.violet.light,
        child: child!,
      ),
      themeMode: dark() ? ThemeMode.dark : ThemeMode.light,
      title: 'Patients App',
    );
  }
}

typedef UI = ReactiveStatelessWidget;

extension ContextX on BuildContext {
  T of<T>() {
    try {
      return watch<T>();
    } catch (_) {
      return read<T>();
    }
  }

  watch<T>() {}

  read<T>() {}
}
