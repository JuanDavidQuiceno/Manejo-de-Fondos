/// Generic repository interface for data operations.
///
/// [T] is the response/data type that will be returned.
/// Each method receives the necessary parameters for its operation.
abstract class DataRepository<T> {
  /// Fetches data. Can be a list, single item, or any type T.
  /// [params] optional parameters for filtering, pagination, etc.
  Future<T> fetch([Map<String, dynamic>? params]);

  /// Refreshes data (same as fetch but semantically different for UI).
  Future<T> refresh([Map<String, dynamic>? params]);

  /// Submits/sends data to the server.
  /// [data] the payload to send.
  /// [params] optional additional parameters.
  Future<T> submit(Map<String, dynamic> data, [Map<String, dynamic>? params]);
}

/// Extended repository with full CRUD operations.
/// Use this when you need create, update, delete operations.
abstract class DataResourceRepository<T> extends DataRepository<T> {
  /// Gets a single item by ID.
  Future<T> getById(String id);

  /// Creates a new item.
  Future<T> create(Map<String, dynamic> data);

  /// Updates an existing item.
  Future<T> update(String id, Map<String, dynamic> data);

  /// Deletes an item by ID.
  Future<void> delete(String id);
}
