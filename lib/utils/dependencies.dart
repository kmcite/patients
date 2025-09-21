import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patients/objectbox.g.dart' as box;
import 'dependencies.config.dart';

final get = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> dependencies() async => await get.init();

@module
abstract class Dependencies {
  @preResolve
  Future<PackageInfo> get appInfo async => await PackageInfo.fromPlatform();
  @preResolve
  Future<box.Store> get store async {
    final path = await getApplicationDocumentsDirectory();
    final appInfo = get<PackageInfo>();
    final store = await box.openStore(
      directory: join(path.path, appInfo.appName),
    );
    return store;
  }

  @preResolve
  Future<Box> get hive async {
    await Hive.initFlutter();
    final box = await Hive.openBox('hive');
    return box;
  }
}
