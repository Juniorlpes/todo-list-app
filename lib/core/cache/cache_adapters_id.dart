/// Central registry for Hive TypeAdapter IDs.
///
/// Every TypeAdapter must have a unique [typeId].
/// Register new adapter IDs here to avoid conflicts.
///
/// Usage:
/// ```dart
/// @HiveType(typeId: CacheAdaptersId.todoModelAdapter)
/// class TodoItemModel { ... }
/// ```
class CacheAdaptersId {
  CacheAdaptersId._();

  static const todoModelAdapter = 1;
  // Add new adapter IDs below:
  // static const userModelAdapter = 2;
}
