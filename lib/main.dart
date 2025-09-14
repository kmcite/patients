// Removed ForUI dependency
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/duties_repository.dart';
import 'package:patients/domain/api/hospital_repository.dart';
import 'package:patients/domain/api/imageries_repository.dart';
import 'package:patients/domain/api/investigations.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/api/pictures_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/domain/api/upcoming_duty_finder.dart';
import 'package:patients/domain/api/user_repository.dart';
import 'package:patients/objectbox.g.dart';
import 'package:patients/ui/app_state_bloc.dart';
import 'package:patients/ui/home/home_page.dart';
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

// Add missing imports for main.dart
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path_provider/path_provider.dart';
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
export 'package:patients/domain/api/navigator.dart';

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
  register<DutiesRepository>(DutiesRepository());
  register<InvestigationsRepository>(InvestigationsRepository());
  register<ImageriesRepository>(ImageriesRepository());
  register<PicturesRepository>(PicturesRepository());
  register<UpcomingDutyFinder>(UpcomingDutyFinder());

  runApp(const App());
}

class App extends Feature<AppStateBloc> {
  const App({super.key});

  @override
  AppStateBloc createBloc() => AppStateBloc();

  @override
  Widget build(BuildContext context, AppStateBloc bloc) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Patients Management System',
      home: bloc.isAuthenticated ? const HomePage() : const LoginPage(),
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4), // Material Purple
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
