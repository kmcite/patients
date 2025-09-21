import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:patients/domain/api/navigator.dart';

import 'dependencies.dart';

/// -------------------------------
/// GLOBAL CONFIG
/// -------------------------------
bool logging = true;
void logInfo(String message) {
  if (logging) log(message, name: 'ARCH');
}

/// -------------------------------
/// RESOURCE (async state management)
/// -------------------------------
enum ResourceStatus { idle, loading, success, error }

class Resource<T> {
  ResourceStatus status = ResourceStatus.idle;
  T? data;
  Object? error;
  String? message;

  Resource();

  bool get isLoading => status == ResourceStatus.loading;
  bool get hasData => status == ResourceStatus.success && data != null;
  bool get hasError => status == ResourceStatus.error;
  bool get isEmpty => status == ResourceStatus.idle;

  void setLoading() {
    status = ResourceStatus.loading;
    data = null;
    error = null;
    message = null;
  }

  void setData(T d) {
    status = ResourceStatus.success;
    data = d;
    error = null;
    message = null;
  }

  void setError(Object e, [String? msg]) {
    status = ResourceStatus.error;
    error = e;
    message = msg;
  }

  /// Execute async operation with automatic state management
  Future<void> execute(Future<T> Function() operation) async {
    setLoading();
    try {
      final result = await operation();
      setData(result);
    } catch (e, stack) {
      setError(e, stack.toString());
    }
  }

  /// Transform data without changing status
  Resource<R> map<R>(R Function(T data) transform) {
    final result = Resource<R>();
    result.status = status;
    result.error = error;
    result.message = message;
    if (hasData) {
      result.data = transform(data as T);
    }
    return result;
  }

  /// Chain operations
  Future<Resource<R>> then<R>(Future<R> Function(T data) operation) async {
    if (!hasData) {
      final result = Resource<R>();
      result.status = status;
      result.error = error;
      result.message = message;
      return result;
    }

    final result = Resource<R>();
    result.setLoading();
    try {
      final newData = await operation(data as T);
      result.setData(newData);
    } catch (e, stack) {
      result.setError(e, stack.toString());
    }
    return result;
  }

  /// Build UI based on resource state
  Widget when({
    Widget Function()? loading,
    Widget Function(T data)? data,
    Widget Function(Object error, String? message)? error,
    Widget Function()? empty,
  }) {
    switch (status) {
      case ResourceStatus.loading:
        return loading?.call() ?? const CircularProgressIndicator();
      case ResourceStatus.success:
        return this.data != null
            ? (data?.call(this.data as T) ?? const SizedBox.shrink())
            : (empty?.call() ?? const SizedBox.shrink());
      case ResourceStatus.error:
        return error?.call(this.error!, message) ??
            Text('Error: ${this.error}');
      case ResourceStatus.idle:
        return empty?.call() ?? const SizedBox.shrink();
    }
  }
}

/// -------------------------------
/// REPOSITORY base
/// - mutable & change-notifier friendly
/// -------------------------------

abstract class Repository extends ChangeNotifier {}

/// -------------------------------
/// BLOC base
/// - init(container) instead of holding BuildContext
// ignore: unintended_html_in_doc_comment
/// - watch<T>() auto-subscribes + auto-disposes listeners
/// - supports multiple watched repos (composition)
/// -------------------------------
abstract class Bloc<U extends Widget> extends ChangeNotifier {
  Navigation get navigator => get();

  late BuildContext context;
  late final U widget;
  final _disposers = <void Function()>[];
  final _watchedRepos = <Repository>{};
  bool _disposed = false;

  /// Override for initialization logic
  void init() {
    initState();
    logInfo('Initialized: $runtimeType');
  }

  /// Override for custom init logic
  void initState() {}

  /// Watch a repository (auto-subscribes to changes)
  T watch<T extends Repository>() {
    final repo = get<T>();

    // Avoid duplicate listeners
    if (_watchedRepos.contains(repo)) return repo;

    repo.addListener(notifyListeners);
    _watchedRepos.add(repo);
    _disposers.add(() => repo.removeListener(notifyListeners));
    logInfo('$runtimeType watching $T $hashCode');
    return repo;
  }

  @override
  void dispose() {
    if (_disposed) return;
    for (var disposer in _disposers) {
      try {
        disposer();
      } catch (_) {}
    }
    _watchedRepos.clear();
    _disposed = true;
    logInfo('Disposed: $runtimeType');
    super.dispose();
  }
}

/// -------------------------------
/// Feature - Simple stateful widget with bloc
/// -------------------------------
abstract class Feature<T extends Bloc<Feature<T>>> extends StatefulWidget {
  const Feature({super.key});

  Navigation get navigator => get();
  // T get controller => get();

  /// Safe: returns the controller resolved & owned by the State.
  /// Throws if accessed before the State has attached (avoid using in ctor).
  T get controller {
    final host = _featureStateExpando[this];
    if (host == null) {
      throw StateError(
        'Controller not attached yet. Access `controller` after the widget is mounted (e.g. not in the constructor).',
      );
    }
    return host.controller as T;
  }

  /// Build UI with the bloc
  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() => _Feature<T>();
}

/// Expando maps widget instance -> its State (weakly)
final Expando<_FeatureStateBase> _featureStateExpando =
    Expando<_FeatureStateBase>();

abstract class _FeatureStateBase {
  Object? get controller;
}

class _Feature<T extends Bloc<Feature<T>>> extends State<Feature<T>>
    implements _FeatureStateBase {
  late final T _controller;

  @override
  T get controller => _controller;

  @override
  void initState() {
    super.initState();
    // resolve once (GetIt should be configured so T is a factory/@injectable)
    _controller = get<T>();
    _controller.init();
    // register mapping widget -> this state
    _featureStateExpando[widget] = this;
    // listen & trigger rebuilds (assuming controller is a ChangeNotifier)
    _controller.addListener(_listener);
    _controller.widget = widget;
    _controller.context = context;
  }

  @override
  void didUpdateWidget(covariant Feature<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // move the expando entry from old widget instance to the new one
    _featureStateExpando[oldWidget] = null;
    _featureStateExpando[widget] = this;
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }

  @override
  void dispose() {
    _featureStateExpando[widget] = null;
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }
}

/// -------------------------------
/// NavigationX
/// -------------------------------
extension NavigationX on StatelessWidget {
  Navigation get navigator => get();
}

/// -------------------------------
/// REACTIVE EXTENSIONS
/// -------------------------------
extension ResourceExtensions<T> on Resource<T> {
  /// Combine with another resource
  Resource<R> combine<U, R>(
    Resource<U> other,
    R Function(T first, U second) combiner,
  ) {
    final result = Resource<R>();

    if (isLoading || other.isLoading) {
      result.setLoading();
    } else if (hasError) {
      result.setError(error!, message);
    } else if (other.hasError) {
      result.setError(other.error!, other.message);
    } else if (hasData && other.hasData) {
      result.setData(combiner(data as T, other.data as U));
    }

    return result;
  }

  /// Filter data
  Resource<T> where(bool Function(T data) predicate) {
    if (!hasData) return this;

    final result = Resource<T>();
    if (predicate(data as T)) {
      result.setData(data as T);
    } else {
      result.status = ResourceStatus.idle;
    }
    return result;
  }
}
