import 'package:hive_flutter/hive_flutter.dart';

import 'architecture.dart';

mixin Hive<T> on Repository<T> {
  late final hive = serve<Box>();

  void save<V extends Storable>(String key, V value) {
    hive.put(key, value.toJson());
  }

  V? load<V extends Storable>(
    String key,
    V Function(Map<String, dynamic> json) fromJson,
  ) {
    final json = hive.get(key);
    return json == null ? null : fromJson(json);
  }
}
// abstract
class HiveRepository<T> = Repository<T> with Hive<T>;

abstract class Storable<V> {
  int get id;
  Map<String, dynamic> toJson();
}
