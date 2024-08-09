// Generic Base Repo
abstract class BaseRepository<T> {
  Future<void> create(T item);
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<void> update(T item);
  Future<void> delete(String id);
}