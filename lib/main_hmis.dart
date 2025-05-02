export 'package:path/path.dart' show join;

import 'package:manager/crud.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:patients/domain/api/router_bloc.dart';
import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// late Store store;
late SharedPreferences prefs;
void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  final appInfo = await PackageInfo.fromPlatform();
  final storageDirectory = Directory(
    join(
      (await getApplicationDocumentsDirectory()).path,
      appInfo.appName,
    ),
  );

  final storagePath = storageDirectory.path;
  store = await openStore(directory: storagePath);
  // Manager.enableLogging();
  prefs = await SharedPreferences.getInstance();
  runApp(App());
}

mixin AppThemeMode {
  ThemeMode get themeMode => settingsRepository.themeMode;
}

class App extends EUI with AppThemeMode {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: context.of<RouterBloc>().router,
      themeMode: themeMode,
      // theme: FlexThemeData.light(),
      // darkTheme: FlexThemeData.dark(),
    );
  }
}
