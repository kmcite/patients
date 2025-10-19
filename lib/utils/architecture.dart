import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:patients/repositories/navigator.dart';
import 'package:patients/utils/services/repository.dart';

import 'get.dart';

/// -------------------------------
/// GLOBAL CONFIG
/// -------------------------------
bool logging = true;
void logInfo(String message) {
  if (logging) log(message, name: 'patients');
}

abstract class Bloc<U extends Widget> extends ChangeNotifier {
  Navigation get navigator => get();
  final subscriptions = <StreamSubscription>{};

  late BuildContext context;
  late final U widget;
  final _disposers = <void Function()>[];
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
    final subscription = repo.watch.listen((_) => notifyListeners());
    if (subscriptions.contains(subscription)) return repo;
    subscriptions.add(subscription);
    _disposers.add(() => subscription.cancel());
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
    subscriptions.clear();
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
///
/// This Expando creates a weak reference mapping between:
/// - Key: Widget instance (Feature<T>)
/// - Value: Its corresponding State object (_Feature<T>)
///
/// This allows the widget to access its controller (BLoC) through the state
/// without having to pass it explicitly as a parameter.
///
/// Example usage:
/// When you call widget.controller, it looks up the state in this expando
/// and returns the controller from that state.
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
    // register mapping widget -> this state
    // This is where the magic happens: associate the widget instance with its state
    _featureStateExpando[widget] = this;
    // listen & trigger rebuilds (assuming controller is a ChangeNotifier)
    _controller.addListener(_listener);
    _controller.widget = widget;
    _controller.context = context;
    _controller.init();
  }

  @override
  void didUpdateWidget(covariant Feature<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When the widget is updated, we need to update the mapping:
    // 1. Remove the old widget from the mapping
    // 2. Add the new widget with the same state
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
    // Clean up the mapping when the state is disposed
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
