import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'get.config.dart';

final get = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> dependencies() async {
  await get.init();
}
