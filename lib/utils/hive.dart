import 'package:hive_flutter/hive_flutter.dart';

import 'architecture.dart';

mixin Hive<T> on Repository<T> {
  late final box = serve<Box>();
}
