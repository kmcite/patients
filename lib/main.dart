import 'package:forui/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/api/user_repository.dart';
import 'package:patients/ui/app_state_bloc.dart';
import 'package:patients/ui/login_page.dart';
import 'package:patients/utils/architecture.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'dart:convert';
export 'dart:io';
export 'objectbox.g.dart';
export 'package:colornames/colornames.dart';
export 'package:flutter/material.dart' hide Action;
export 'package:flutter_native_splash/flutter_native_splash.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:objectbox/objectbox.dart';
export 'package:path_provider/path_provider.dart';
export 'package:patients/domain/models/user.dart';
export 'package:patients/ui/home/home_page.dart';
export 'package:patients/domain/api/calculate_total_duty_hours.dart';
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
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  final appInfo = await PackageInfo.fromPlatform();
  final path = await getApplicationDocumentsDirectory();
  final prefs = await SharedPreferences.getInstance();
  final store = await openStore(directory: join(path.path, appInfo.appName));
  
  // Register dependencies using new architecture
  register<SharedPreferences>(prefs);
  register<Store>(store);
  register<AuthenticationRepository>(AuthenticationRepository());
  register<SettingsRepository>(SettingsRepository());
  register<UserRepository>(UserRepository());
  register<PatientsRepository>(PatientsRepository());
  register<PatientTypesRepository>(PatientTypesRepository());
  register<HospitalRepository>(HospitalRepository());

  runApp(const App());
}

class App extends BlocWidget<AppStateBloc> {
  const App({super.key});
  
  @override
  AppStateBloc createBloc() => AppStateBloc();

  @override
  Widget build(BuildContext context, AppStateBloc bloc) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: bloc.isAuthenticated ? const HomePage() : const LoginPage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return FTheme(
          data: FThemes.violet.light, // Simplified for now
          child: child!,
        );
      },
    );
  }
}
