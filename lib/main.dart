import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/features/home.dart';
import 'package:patients/repositories/navigator.dart';
import 'package:patients/repositories/settings_repository.dart';
import 'package:patients/utils/architecture.dart';
import 'package:patients/utils/get.dart';
import 'package:patients/utils/locator.dart';
import 'package:patients/utils/themes/dark.dart';
import 'package:patients/utils/themes/light.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await dependencies();
  find(ThemeModeBloc());
  runApp(
    ApplicationView(),
  );
}

@injectable
class ThemeModeBloc extends Bloc<ApplicationView> {
  // late AuthenticationRepository authRepository = watch();
  late SettingsRepository settingsRepository = watch();

  // bool get authenticated => authRepository.isAuthenticated;
  // bool get loading => authRepository.auth.isLoading;
  ThemeMode get themeMode => settingsRepository.value;

  @override
  void initState() {
    FlutterNativeSplash.remove();
  }
}

class ApplicationView extends StatelessWidget {
  const ApplicationView({super.key});

  @override
  Widget build(context) {
    FlutterNativeSplash.remove();
    return O(
      (context) => MaterialApp(
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
        themeMode: themeModeBloc.themeMode,
      ),
    );
  }
}
