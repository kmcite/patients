// spark.dart
// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';
import 'package:patients/utils/services/async_state.dart';
import 'package:patients/utils/services/persistence_config.dart';
import 'package:patients/utils/services/spark.dart';

/// -----------------
/// AsyncSpark: exposes AsyncState and stream
/// -----------------
class AsyncSpark<T> implements Spark<T> {
  final PersistenceConfig<T>? _persistence;
  T? _value;
  AsyncState<T> _state = AsyncState.loading();
  final _controller = StreamController<AsyncState<T>>.broadcast();
  StreamSubscription<String?>? _watchSub;

  AsyncSpark(
    Future<T> initialFuture, {
    PersistenceConfig<T>? persistence,
  }) : _persistence = persistence {
    // start init
    _controller.add(_state);
    _init(initialFuture);
  }

  @override
  T get value {
    if (_value == null) {
      throw StateError('Value not yet loaded');
    }
    return _value!;
  }

  @override
  AsyncState<T> get state => _state;

  @override
  Stream<AsyncState<T>> get watch => _controller.stream;

  void _emit(AsyncState<T> s) {
    _state = s;
    if (s.hasData) {
      _value = s.data;
    }
    _controller.add(s);
  }

  Future<void> _init(Future<T> initialFuture) async {
    try {
      final resolved = await initialFuture;
      if (_persistence != null) {
        _emit(AsyncState.loading());
        try {
          final raw = await _persistence.storage.read(_persistence.key);
          if (raw != null) {
            final stored = _persistence.serializer.decode(raw);
            _emit(AsyncState.data(stored));
          } else {
            _emit(AsyncState.data(resolved));
          }
        } catch (e) {
          _emit(AsyncState.error(e));
        }
        _watchSub = _persistence.storage.watch(_persistence.key).listen((raw) {
          if (raw != null) {
            try {
              final obj = _persistence.serializer.decode(raw);
              _emit(AsyncState.data(obj));
            } catch (e) {
              _emit(AsyncState.error(e));
            }
          } else {
            _emit(AsyncState.data(resolved));
          }
        });
      } else {
        _emit(AsyncState.data(resolved));
      }
    } catch (e) {
      _emit(AsyncState.error(e));
    }
  }

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
      await _persistence.storage
          .save(_persistence.key, _persistence.serializer.encode(newValue));
    }
  }

  @override
  Future<void> delete() async {
    if (_persistence != null) {
      await _persistence.storage.delete(_persistence.key);
    }
  }

  @override
  void dispose() {
    _watchSub?.cancel();
    _controller.close();
  }
}
