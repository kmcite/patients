// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';

/// -----------------
/// Storage abstraction (implement for Hive, SharedPreferences, file, ...)
/// -----------------
abstract class Storage {
  Future<void> save(String key, String value);
  Future<String?> read(String key);
  Stream<String?> watch(String key);
  Future<void> delete(String key);
}
