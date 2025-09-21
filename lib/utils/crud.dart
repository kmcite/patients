import 'package:objectbox/objectbox.dart';
import 'package:patients/utils/dependencies.dart';
import 'architecture.dart';

/// CRUD Repository - integrates ObjectBox with new architecture
abstract class CrudRepository<T> extends Repository {
  CrudRepository() {
    loadAll();
  }
  late final store = get<Store>();
  late final crud = store.box<T>();
  final items = Resource<List<T>>();

  /// Load all items from database
  Future<void> loadAll() async {
    await items.execute(() async {
      return crud.getAll();
    });
    notifyListeners();
  }

  /// Get all items (sync)
  Iterable<T> getAll() => items.data ?? [];

  /// Get single item by ID
  T? getById(int id) => crud.get(id);

  /// Add or update item
  void put(T entity) {
    crud.put(entity);
    loadAll(); // Refresh the resource
  }

  /// Remove item
  void remove(T entity) {
    final id = (entity as dynamic).id;
    if (id != null) {
      crud.remove(id);
      loadAll(); // Refresh the resource
    }
  }

  /// Remove all items
  void removeAll() {
    crud.removeAll();
    loadAll(); // Refresh the resource
  }

  /// Get count
  int get length => items.data?.length ?? 0;

  /// Watch for changes (ObjectBox stream)
  Stream<List<T>> watch() {
    return crud
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
