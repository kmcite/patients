import 'package:forui/theme.dart';
import 'package:manager/dark/dark_repository.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
export 'package:patients/ui/home/home_page.dart';
export 'package:patients/domain/api/duty_hours_calculator.dart';
export 'package:patients/domain/api/duties_repository.dart';
export 'package:patients/ui/personal/duty_roster.dart';
export 'package:patients/ui/personal/roster_table.dart';
export 'package:patients/ui/personal/table_cell_builder.dart';
export 'package:patients/ui/personal/upcoming_duties.dart';
export 'package:patients/domain/api/upcoming_duty_finder.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
export 'package:uuid/uuid.dart';
export 'ui/patients/patients/patients_page.dart';

late SharedPreferences prefs;

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
    widgetsBinding: widgetsBinding,
  );
  prefs = await SharedPreferences.getInstance();
  manager(
    MyApp(),
    openStore: openStore,
  );
}

bool get dark => darkRepository.state;
ThemeMode get themeMode => dark ? ThemeMode.dark : ThemeMode.light;

class MyApp extends UI {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return FTheme(
          data: dark ? FThemes.orange.dark : FThemes.violet.light,
          child: child!,
        );
      },
      themeMode: themeMode,
    );
  }
}

typedef UI = ReactiveStatelessWidget;
