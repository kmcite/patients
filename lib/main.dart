import 'package:forui/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/api/user_repository.dart';
import 'package:patients/main.dart';
export 'package:patients/utils/architecture.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'dart:convert';
export 'dart:io';
export 'objectbox.g.dart';
export 'package:colornames/colornames.dart';
export 'package:flutter/material.dart' hide Action;
export 'package:flutter_native_splash/flutter_native_splash.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:manager/manager.dart'
    hide Bloc, UI, Repository, logging, repositories, services;

export 'package:objectbox/objectbox.dart';
export 'package:path_provider/path_provider.dart';
export 'package:patients/domain/models/user.dart';
export 'package:patients/ui/home/home_page.dart';
export 'package:patients/domain/api/duty_hours_calculator.dart';
export 'package:patients/domain/api/duties_repository.dart';
export 'package:patients/ui/personal/duty_roster.dart';
export 'package:patients/ui/personal/roster_table.dart';
export 'package:patients/ui/personal/table_cell_builder.dart';
export 'package:patients/ui/personal/upcoming_duties.dart';
export 'package:patients/domain/api/upcoming_duty_finder.dart';
export 'package:uuid/uuid.dart';
export 'ui/patients/patients/patients_page.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
    widgetsBinding: widgetsBinding,
  );
  final appInfo = await PackageInfo.fromPlatform();
  final path = await getApplicationDocumentsDirectory();
  find<SharedPreferences>(await SharedPreferences.getInstance());
  final store = await openStore(directory: join(path.path, appInfo.appName));
  find<Store>(store);
  repository(SettingsRepository());
  repository(UserRepository());
  repository(PatientsRepository());
  repository(PatientTypesRepository());
  repository(HospitalRepository());

  runApp(App());
}

class AppBloc extends Bloc {
  late final SettingsRepository settingsRepository = watch();

  bool get dark => settingsRepository.dark;
  ThemeMode get themeMode => dark ? ThemeMode.dark : ThemeMode.light;
}

class App extends UI<AppBloc> {
  const App({super.key});
  @override
  AppBloc create() => AppBloc();

  @override
  Widget build(context, controller) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return FTheme(
          data: controller.dark ? FThemes.orange.dark : FThemes.violet.light,
          child: child!,
        );
      },
      themeMode: controller.themeMode,
    );
  }
}
