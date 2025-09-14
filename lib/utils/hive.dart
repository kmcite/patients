import 'package:hive_flutter/hive_flutter.dart';
import 'architecture.dart';

/// Hive Repository - integrates Hive with new architecture
abstract class HiveRepository<T extends Storable> extends Repository {
  late final Box hive;
  final Resource<Map<String, T>> items = Resource<Map<String, T>>();

  @override
  void init() {
    hive = get<Box>();
    loadAll();
  }

  /// Load all items from Hive
  Future<void> loadAll() async {
    await items.execute(() async {
      final Map<String, T> result = {};
      for (var key in hive.keys) {
        final json = hive.get(key);
        if (json != null) {
          result[key] = fromJson(json);
        }
      }
      return result;
    });
    notifyListeners();
  }

  /// Override this to provide deserialization
  T fromJson(Map<String, dynamic> json);

  /// Save item
  void save(String key, T value) {
    hive.put(key, value.toJson());
    loadAll(); // Refresh the resource
  }

  /// Load single item
  T? load(String key) {
    final json = hive.get(key);
    return json == null ? null : fromJson(json);
  }

  /// Remove item
  void removeItem(String key) {
    hive.delete(key);
    loadAll(); // Refresh the resource
  }

  /// Clear all items
  void clear() {
    hive.clear();
    loadAll(); // Refresh the resource
  }
}

/// Mixin for existing repositories that want Hive functionality
mixin HiveMixin on Repository {
  late final Box hive;

  void initHive() {
    hive = get<Box>();
  }

  void save<V extends Storable>(String key, V value) {
    hive.put(key, value.toJson());
    notifyListeners();
  }

  V? load<V extends Storable>(
    String key,
    V Function(Map<String, dynamic> json) fromJson,
  ) {
    final json = hive.get(key);
    return json == null ? null : fromJson(json);
  }

  void removeItem(String key) {
    hive.delete(key);
    notifyListeners();
  }

  void clear() {
    hive.clear();
    notifyListeners();
  }
}

/// Interface for objects that can be stored in Hive
abstract class Storable {
  int get id;
  Map<String, dynamic> toJson();
}
