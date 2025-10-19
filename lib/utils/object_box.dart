import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patients/objectbox.g.dart' as objectbox;
import 'package:hive_flutter/hive_flutter.dart' as hivebox;
import 'package:patients/utils/get.dart';

@module
abstract class Dependencies {
  @preResolve
  Future<PackageInfo> get appInfo async => await PackageInfo.fromPlatform();
  @preResolve
  Future<objectbox.Store> get store async {
    final path = await getApplicationDocumentsDirectory();
    final appInfo = get<PackageInfo>();
    final store = await objectbox.openStore(
      directory: join(path.path, appInfo.appName),
    );
    return store;
  }

  @preResolve
  Future<hivebox.Box> get box async {
    final appInfo = get<PackageInfo>();
    await hivebox.Hive.initFlutter();
    final box = await hivebox.Hive.openBox(appInfo.appName);
    return box;
  }
}
