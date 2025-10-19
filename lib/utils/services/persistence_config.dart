// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'package:patients/utils/services/serializer/serializer.dart';
import 'package:patients/utils/services/storage.dart';

/// -----------------
/// Persistence config
/// -----------------
class PersistenceConfig<T> {
  final String key;
  final Storage storage;
  final Serializer<T> serializer;
  PersistenceConfig({
    required this.key,
    required this.storage,
    required this.serializer,
  });
}
