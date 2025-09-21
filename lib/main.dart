import 'package:flutter/material.dart';
import 'package:patients/ui/authentication.dart';
import 'package:patients/ui/home.dart';
import 'package:patients/utils/architecture.dart';
import 'package:patients/utils/dependencies.dart';

// Add missing imports for main.dart
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:patients/utils/themes/dark.dart';
import 'package:patients/utils/themes/light.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/settings_repository.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dependencies();
  runApp(const ApplicationView());
}

@injectable
class ApplicationBloc extends Bloc<ApplicationView> {
  late AuthenticationRepository authRepository = watch();
  late SettingsRepository settingsRepository = watch();

  @override
  void initState() {
    FlutterNativeSplash.remove();
  }

  bool get authenticated => authRepository.isAuthenticated;
  bool get loading => authRepository.auth.isLoading;
  ThemeMode get themeMode => settingsRepository.themeMode;
}

class ApplicationView extends Feature<ApplicationBloc> {
  const ApplicationView({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      navigatorKey: navigator.key,
      debugShowCheckedModeBanner: false,
      home: controller.authenticated
          ? const HomeView()
          : const AuthenticationView(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: controller.themeMode,
    );
  }
}
