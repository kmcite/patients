import 'dart:developer';
import 'package:flutter/material.dart';

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
/// LOCATOR (simple service locator pattern)
/// -------------------------------
class Locator {
  final Map<Type, dynamic> _instances = {};

  /// Register instance
  void register<T>(T instance, {bool replace = false}) {
    final type = T;
    if (_instances.containsKey(type) && !replace) {
      throw Exception('$type already registered');
    }
    _instances[type] = instance;

    // Auto-attach repositories
    if (instance is Repository) {
      instance.attach(this);
    }

    logInfo('Registered: $type');
  }

  /// Get instance
  T get<T>() {
    final type = T;
    final instance = _instances[type];
    if (instance != null) return instance as T;
    throw Exception('$type not registered');
  }

  /// Check if registered
  bool has<T>() => _instances.containsKey(T);

  /// Unregister
  void unregister<T>() {
    final instance = _instances.remove(T);
    if (instance is Repository) {
      try {
        instance.disposeRepository();
      } catch (_) {}
    }
    logInfo('Unregistered: $T');
  }

  /// Clear all
  void clear() {
    for (var instance in _instances.values) {
      if (instance is Repository) {
        try {
          instance.disposeRepository();
        } catch (_) {}
      }
    }
    _instances.clear();
    logInfo('Locator cleared');
  }
}

/// Global locator instance
final locator = Locator();

/// Convenience functions
void register<T>(T instance, {bool replace = false}) =>
    locator.register<T>(instance, replace: replace);
T get<T>() => locator.get<T>();
bool has<T>() => locator.has<T>();

/// -------------------------------
/// REPOSITORY base
/// - attach(container) called on registration
/// - mutable & change-notifier friendly
/// -------------------------------
abstract class Repository extends ChangeNotifier {
  Locator? _locator;

  /// Called when registered in locator
  void attach(Locator locator) {
    _locator = locator;
    init();
    logInfo('Repository attached: $runtimeType');
  }

  /// Override for initialization logic
  void init() {}

  /// Get dependency from locator
  T get<T>() => (_locator ?? locator).get<T>();

  void disposeRepository() {
    try {
      dispose();
      logInfo('Disposed: $runtimeType');
    } catch (_) {}
  }
}

/// -------------------------------
/// BLOC base
/// - init(container) instead of holding BuildContext
// ignore: unintended_html_in_doc_comment
/// - watch<T>() auto-subscribes + auto-disposes listeners
/// - supports multiple watched repos (composition)
/// -------------------------------
abstract class Bloc extends ChangeNotifier {
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
    repo.addListener(notifyListeners);
    _disposers.add(() => repo.removeListener(notifyListeners));
    logInfo('$runtimeType watching $T');
    return repo;
  }

  /// Get dependency without watching
  T get<T>() => locator.get<T>();

  @override
  void dispose() {
    if (_disposed) return;
    for (var disposer in _disposers) {
      disposer();
    }
    _disposed = true;
    logInfo('Disposed: $runtimeType');
    super.dispose();
  }
}

/// -------------------------------
/// Feature - Simple stateful widget with bloc
/// -------------------------------
abstract class Feature<T extends Bloc> extends StatefulWidget {
  const Feature({super.key});

  /// Create the bloc instance
  T createBloc();

  /// Build UI with the bloc
  Widget build(BuildContext context, T bloc);

  @override
  State<StatefulWidget> createState() => _FeatureState<T>();
}

class _FeatureState<T extends Bloc> extends State<Feature<T>> {
  late final T bloc;

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    bloc = widget.createBloc()
      ..init()
      ..addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, bloc);
  }

  @override
  void dispose() {
    bloc.removeListener(_listener);
    bloc.dispose();
    super.dispose();
  }
}

/// -------------------------------
/// Example usage
/// -------------------------------
/*
class UserRepository extends Repository {
  final Resource<List<String>> users = Resource<List<String>>();

  Future<void> loadUsers() async {
    await users.execute(() async {
      await Future.delayed(const Duration(seconds: 1));
      return ['Alice', 'Bob', 'Charlie'];
    });
    notifyListeners();
  }
}

class UserBloc extends Bloc {
  late final UserRepository repo;

  @override
  void initState() {
    repo = watch<UserRepository>();
  }

  void loadUsers() => repo.loadUsers();
}

class UserScreen extends BlocWidget<UserBloc> {
  const UserScreen({super.key});

  @override
  UserBloc createBloc() => UserBloc();

  @override
  Widget build(BuildContext context, UserBloc bloc) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: bloc.repo.users.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (users) => ListView(
          children: users.map((user) => ListTile(title: Text(user))).toList(),
        ),
        error: (error, message) => Center(child: Text('Error: $error')),
        empty: () => Center(
          child: ElevatedButton(
            onPressed: bloc.loadUsers,
            child: const Text('Load Users'),
          ),
        ),
      ),
    );
  }
}

void main() {
  // Register dependencies
  register<UserRepository>(UserRepository());
  
  runApp(MaterialApp(home: const UserScreen()));
}
*/
