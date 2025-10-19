import 'package:flutter/material.dart';
import 'package:patients/features/home.dart';
import 'package:patients/repositories/navigator.dart';
import 'package:patients/utils/architecture.dart';
import 'package:patients/utils/get.dart';

// Add missing imports for main.dart
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:patients/utils/themes/dark.dart';
import 'package:patients/utils/themes/light.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/repositories/settings_repository.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dependencies();
  runApp(
    ApplicationView(),
  );
}

@injectable
class ApplicationBloc extends Bloc<ApplicationView> {
  // late AuthenticationRepository authRepository = watch();
  late SettingsRepository settingsRepository = watch();

  @override
  void initState() {
    FlutterNativeSplash.remove();
  }

  // bool get authenticated => authRepository.isAuthenticated;
  // bool get loading => authRepository.auth.isLoading;
  ThemeMode get themeMode => settingsRepository.value;
}

class ApplicationView extends Feature<ApplicationBloc> {
  const ApplicationView({super.key});

  @override
  Widget build(context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      navigatorKey: get<Navigation>().key,
      debugShowCheckedModeBanner: false,
      home:
          //  controller.authenticated
          //     ?
          const HomeView()
      //  :
      // PatientsView()
      ,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: controller.themeMode,
    );
  }
}
