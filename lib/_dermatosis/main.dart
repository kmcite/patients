export 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:patients/_dermatosis/domain/api/authentication_repository.dart';
import 'package:patients/_dermatosis/domain/api/settings_repository.dart';
import 'package:patients/_dermatosis/navigator.dart';
import 'package:patients/_dermatosis/objectbox.g.dart';

import 'features/authentication/login_page.dart';
import 'features/home/home_page.dart';
import 'main.dart';

export 'dart:async';
export 'dart:io';

export 'package:manager/manager.dart';
export 'package:path_provider/path_provider.dart';
export 'package:states_rebuilder/states_rebuilder.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  manager(App(), openStore: openStore);
}

mixin AppBloc {
  ThemeMode get themeMode => settingsRepository.themeMode();
  bool get dark => themeMode == ThemeMode.dark;
  bool get authenticated => authenticationRepository.authenticated;
}

class App extends UI with AppBloc {
  const App({super.key});

  @override
  void didMountWidget(context) => FlutterNativeSplash.remove();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      builder: (context, child) => FTheme(
        data: dark ? FThemes.green.dark : FThemes.orange.light,
        child: child!,
      ),
      home: authenticated ? HomePage() : LoginPage(),
    );
  }
}
