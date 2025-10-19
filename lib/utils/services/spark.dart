// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';
import 'package:patients/utils/services/async_state.dart';

/// -----------------
/// Common base interface (useful for typed collections)
/// -----------------
abstract class Spark<T> {
  /// Current value (may throw if not yet loaded for async variants)
  T get value;

  /// Unified state stream: emits AsyncState<T> for both sync & async sparks
  Stream<AsyncState<T>> get watch;

  /// Current state (loading, data, or error)
  AsyncState<T> get state;

  /// Register callbacks (convenience)
  StreamSubscription on({
    void Function()? loading,
    void Function(T value)? data,
    void Function(Object error)? error,
  });

  /// Update the value
  Future<void> update(T newValue);

  /// Delete the value
  Future<void> delete();

  /// Dispose of resources
  void dispose();
}
