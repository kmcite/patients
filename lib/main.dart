import 'package:patients/main.dart';
import 'package:patients/navigation/navigation_bloc.dart';

export 'dart:convert';
export 'dart:io';
export 'objectbox.g.dart';
export 'package:colornames/colornames.dart';
export 'package:flex_color_scheme/flex_color_scheme.dart';
export 'package:flutter/material.dart' hide Action;
export 'package:flutter_native_splash/flutter_native_splash.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:manager/manager.dart';
export 'package:objectbox/objectbox.dart';
export 'package:path_provider/path_provider.dart';
export 'package:patients/user/user.dart';
export 'package:patients/user/user_ui.dart';
export 'package:patients/home_page.dart';
export 'package:patients/roster/duty_hours_calculator.dart';
export 'package:patients/roster/roster_manager.dart';
export 'package:patients/roster/roster_page.dart';
export 'package:patients/roster/roster_table.dart';
export 'package:patients/roster/table_cell_builder.dart';
export 'package:patients/roster/upcoming_duties.dart';
export 'package:patients/roster/upcoming_duty_finder.dart';
export 'package:patients/settings/border_radius_modifier.dart';
export 'package:patients/settings/settings.dart';
export 'package:patients/settings/settings_page.dart';
export 'package:states_rebuilder/scr/state_management/common/logger.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
export 'package:uuid/uuid.dart';
export 'patients/patients_page.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await directoryRM.initializeState();
  store = await openStore(
    directory: join(directory.path, 'patients'),
  );
  await RM.storageInitializer(HiveStorage());
  runApp(const PatientsApp());
}

class PatientsApp extends UI {
  const PatientsApp({super.key});
  @override
  void didMountWidget(BuildContext context) {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator.key,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: FlexThemeData.light(
        scheme: FlexScheme.aquaBlue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: materialColor(),
        ),
        subThemesData: FlexSubThemesData(
          defaultRadius: borderRadius(),
          inputDecoratorRadius: borderRadius(),
          chipRadius: borderRadius(),
          cardElevation: borderRadius(),
        ),
        lightIsWhite: true,
        useMaterial3: true,
        appBarElevation: 10,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 9,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.aquaBlue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: materialColor(),
          brightness: Brightness.dark,
        ),
        subThemesData: FlexSubThemesData(
          defaultRadius: borderRadius(),
          inputDecoratorRadius: borderRadius(),
          chipRadius: borderRadius(),
          cardElevation: borderRadius(),
        ),
        darkIsTrueBlack: true,
        useMaterial3: true,
        appBarElevation: 10,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 8,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      themeMode: themeMode(),
      title: 'Patients App', // Added app title
    );
  }
}

final directoryRM = RM.injectFuture(getApplicationDocumentsDirectory);
Directory get directory => directoryRM.state;
// late Store store;
