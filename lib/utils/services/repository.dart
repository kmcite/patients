// spark.dart
// ignore_for_file: unintended_html_in_doc_comment
import 'package:patients/utils/services/base_spark.dart';
import 'package:patients/utils/services/spark.dart';

/// -----------------
/// Repository: exposes `value` (non-nullable) + state stream
/// -----------------

abstract class Repository<T> extends BaseSpark<T> implements Spark<T> {
  T get initialState;

  Repository({super.persistence}) : super() {
    // Initialize with initial state using the public update method
    update(initialState);
  }

  @override
  T? getInitialValueSync() => initialState;

  @override
  T get value => initialState;
}
