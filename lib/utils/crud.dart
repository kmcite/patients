import 'package:objectbox/objectbox.dart';
import 'architecture.dart';

/// CRUD Repository - integrates ObjectBox with new architecture
abstract class CrudRepository<T> extends Repository {
  late final Store store;
  late final Box<T> crud;
  final Resource<List<T>> items = Resource<List<T>>();

  @override
  void init() {
    store = get<Store>();
    crud = store.box<T>();
    loadAll();
  }

  /// Load all items from database
  Future<void> loadAll() async {
    await items.execute(() async {
      return crud.getAll();
    });
    notifyListeners();
  }

  /// Get all items (sync)
  Iterable<T> getAll() => crud.getAll();

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
  int get length => crud.count();

  /// Watch for changes (ObjectBox stream)
  Stream<List<T>> watchChanges() {
    return crud
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}

/// Mixin for existing repositories that want CRUD functionality
mixin CRUD<T> on Repository {
  late final Store store;
  late final Box<T> crud;

  void initCrud() {
    store = get<Store>();
    crud = store.box<T>();
  }

  Iterable<T> getAll() => crud.getAll();
  T? getById(int id) => crud.get(id);

  void put(T entity) {
    crud.put(entity);
    notifyListeners();
  }

  void remove(T entity) {
    final id = (entity as dynamic).id;
    if (id != null) {
      crud.remove(id);
      notifyListeners();
    }
  }

  void removeAll() {
    crud.removeAll();
    notifyListeners();
  }

  int get length => crud.count();

  Stream<List<T>> watchChanges() {
    return crud
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
