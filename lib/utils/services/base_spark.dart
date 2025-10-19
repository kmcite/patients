// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';
import 'package:meta/meta.dart';
import 'package:patients/utils/services/async_state.dart';
import 'package:patients/utils/services/persistence_config.dart';
import 'package:patients/utils/services/spark.dart';

/// -----------------
/// BaseSpark: A unified base implementation for both sync and async data sources
/// -----------------
abstract class BaseSpark<T> implements Spark<T> {
  final PersistenceConfig<T>? _persistence;
  T? _value;
  AsyncState<T> _state = AsyncState.loading();
  final _controller = StreamController<AsyncState<T>>.broadcast();
  StreamSubscription<String?>? _watchSub;

  BaseSpark({PersistenceConfig<T>? persistence})
      : _persistence = persistence,
        super() {
    if (persistence != null) {
      _loadAndWatch();
    }
  }

  @override
  T get value {
    if (_value == null && !_state.hasData) {
      throw StateError('Value not yet loaded');
    }
    return _value as T;
  }

  @override
  AsyncState<T> get state => _state;

  @override
  Stream<AsyncState<T>> get watch => _controller.stream;

  // Make _emit protected so subclasses can use it
  @protected
  void _emit(AsyncState<T> s) {
    _state = s;
    if (s.hasData) {
      _value = s.data;
    }
    _controller.add(s);
  }

  Future<void> _loadAndWatch() async {
    if (_persistence == null) return;
    
    _emit(AsyncState.loading());
    try {
      final raw = await _persistence!.storage.read(_persistence!.key);
      if (raw != null) {
        final decoded = _persistence!.serializer.decode(raw);
        _emit(AsyncState.data(decoded));
      } else {
        // If no persisted data, try to get initial value from subclass
        final initialValue = await getInitialValue();
        if (initialValue != null) {
          _emit(AsyncState.data(initialValue));
        }
      }
    } catch (e) {
      _emit(AsyncState.error(e));
    }
    
    _watchSub = _persistence!.storage.watch(_persistence!.key).listen((raw) {
      if (raw != null) {
        try {
          final obj = _persistence!.serializer.decode(raw);
          _emit(AsyncState.data(obj));
        } catch (e) {
          _emit(AsyncState.error(e));
        }
      } else {
        // Handle deletion
        try {
          final initialValue = getInitialValueSync();
          if (initialValue != null) {
            _emit(AsyncState.data(initialValue));
          }
        } catch (e) {
          _emit(AsyncState.error(e));
        }
      }
    });
  }

  /// Override to provide initial value for async loading
  Future<T?> getInitialValue() async => null;

  /// Override to provide initial value for sync operations
  T? getInitialValueSync() => null;

  @override
  StreamSubscription on({
    void Function()? loading,
    void Function(T value)? data,
    void Function(Object error)? error,
  }) {
    return watch.listen((s) {
      if (s.isLoading) {
        loading?.call();
      } else if (s.error != null) {
        error?.call(s.error!);
      } else {
        data?.call(s.data as T);
      }
    });
  }

  @override
  Future<void> update(T newValue) async {
    _emit(AsyncState.data(newValue));
    if (_persistence != null) {
      await _persistence!.storage
          .save(_persistence!.key, _persistence!.serializer.encode(newValue));
    }
  }

  @override
  Future<void> delete() async {
    if (_persistence != null) {
      await _persistence!.storage.delete(_persistence!.key);
    }
  }

  @override
  void dispose() {
    _watchSub?.cancel();
    _controller.close();
  }
}