import 'package:hive_flutter/hive_flutter.dart';
import 'package:patients/utils/get.dart';
import 'package:patients/utils/services/storage.dart';

class HiveStorage extends Storage {
  @override
  Future<void> delete(String key) {
    return get<Box>().delete(key);
  }

  @override
  Future<String?> read(String key) {
    return get<Box>().get(key);
  }

  @override
  Future<void> save(String key, String value) {
    return get<Box>().put(key, value);
  }

  @override
  Stream<String?> watch(String key) {
    return get<Box>().watch(key: key).map((event) => event.value);
  }
}
