import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:hive/hive.dart';

import 'cache_box_enum.dart';

/// A generic cache controller using Hive.
///
/// The `ValueType` is the type of data to be stored. It must be either a
/// Hive-supported primitive type or a class with a registered TypeAdapter.
///
/// Pass the [CacheBox] enum through the constructor. The enum value
/// determines the box name (lowercased).
///
/// Example:
/// ```dart
/// final cache = CacheController<TodoItemModel>(cacheBoxEnum: CacheBox.todoItem);
/// ```
///
/// For custom objects, create a TypeAdapter and register its `typeId` in
/// [CacheAdaptersId] to avoid conflicts. Then register the adapter in
/// the app's initialization (e.g., `initHive()` in main.dart).
class CacheController<ValueType> {
  final CacheBox cacheBoxEnum;
  final bool needBeEncrypted;
  late final String _boxName;
  Box<ValueType>? _box;

  CacheController({
    required this.cacheBoxEnum,
    this.needBeEncrypted = false,
  }) {
    _boxName = cacheBoxEnum
        .toString()
        .substring(cacheBoxEnum.toString().indexOf('.') + 1)
        .toLowerCase();
  }

  Future<void> _openBox() async {
    if (_box == null || !(_box?.isOpen ?? true)) {
      try {
        final keyBox = await Hive.openBox<Uint8List>('encryptionKeyBoxV2');

        if (!keyBox.containsKey('key')) {
          final key = Hive.generateSecureKey() as Uint8List;
          await keyBox.put('key', key);
        }

        _box = Hive.isBoxOpen(_boxName)
            ? Hive.box(_boxName)
            : await Hive.openBox(
                _boxName,
                encryptionCipher:
                    needBeEncrypted ? HiveAesCipher(keyBox.get('key')!) : null,
              );
      } catch (e) {
        log('Erro box: $e', name: 'Cache', error: e);
      }
    }
  }

  /// Checks whether the box contains the [key].
  Future<bool> containsKey(dynamic key) async {
    try {
      await _openBox();
      return _box!.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Get the cached value by [key].
  Future<ValueType?> getByKey(dynamic key, {ValueType? defaultValue}) async {
    try {
      await _openBox();
      return _box?.get(key, defaultValue: defaultValue);
    } catch (e) {
      return null;
    }
  }

  /// Get the cached value by [index].
  Future<ValueType?> getByIndex(int index) async {
    try {
      await _openBox();
      return _box!.getAt(index);
    } catch (e) {
      return null;
    }
  }

  /// Saves the [value] with an auto-increment key.
  Future<int?> write(ValueType value) async {
    try {
      await _openBox();
      return _box!.add(value);
    } catch (e) {
      return null;
    }
  }

  /// Saves multiple [values] with auto-increment keys.
  Future<Iterable<int>?> writeMany(Iterable<ValueType> values) async {
    try {
      await _openBox();
      return _box!.addAll(values);
    } catch (e) {
      return null;
    }
  }

  /// Saves the [value] at the given [key].
  Future<bool> writeByKey(dynamic key, ValueType value) async {
    try {
      await _openBox();
      await _box!.put(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Saves multiple values mapped by their keys.
  Future<bool> writeManyByKey(Map<dynamic, ValueType> values) async {
    try {
      await _openBox();
      await _box!.putAll(values);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Saves the [value] at the given [index].
  Future<bool> writeByIndex(int index, ValueType value) async {
    try {
      await _openBox();
      await _box!.putAt(index, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Removes the entry at the given [key].
  Future<bool> deleteByKey(dynamic key) async {
    try {
      await _openBox();
      await _box!.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Removes the entry at the given [index].
  Future<bool> deleteByIndex(int index) async {
    try {
      await _openBox();
      await _box!.deleteAt(index);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Removes all entries with the given [keys].
  Future<bool> deleteManyByKeys(Iterable<dynamic> keys) async {
    try {
      await _openBox();
      await _box!.deleteAll(keys);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Removes all entries from the box.
  Future<bool> clear() async {
    try {
      await _openBox();
      await _box!.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns the key at the given [index].
  Future<dynamic> keyAt(int index) async {
    try {
      await _openBox();
      return _box!.keyAt(index);
    } catch (e) {
      return null;
    }
  }

  /// Returns the values between [startKey] and [endKey].
  Future<Iterable<ValueType>?> valuesBetween({
    required dynamic startKey,
    required dynamic endKey,
  }) async {
    try {
      await _openBox();
      return _box!.valuesBetween(startKey: startKey, endKey: endKey);
    } catch (e) {
      return null;
    }
  }

  /// Returns a broadcast stream of change events.
  Future<Stream<BoxEvent>?> watch(dynamic key) async {
    try {
      await _openBox();
      return _box!.watch(key: key);
    } catch (e) {
      return null;
    }
  }

  /// Returns `true` if there are no entries in this box.
  Future<bool> get isEmpty async {
    try {
      await _openBox();
      return _box!.isEmpty;
    } catch (e) {
      return true;
    }
  }

  /// Returns `true` if there is at least one entry in this box.
  Future<bool> get isNotEmpty async {
    try {
      await _openBox();
      return _box!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Whether this box is currently open.
  Future<bool?> get isBoxOpen async {
    try {
      await _openBox();
      return _box!.isOpen;
    } catch (e) {
      return null;
    }
  }

  /// All the keys in the box.
  Future<Iterable<dynamic>?> get keys async {
    try {
      await _openBox();
      return _box!.keys;
    } catch (e) {
      return null;
    }
  }

  /// The number of entries in the box.
  Future<int> get length async {
    try {
      await _openBox();
      return _box!.length;
    } catch (e) {
      return 0;
    }
  }

  /// The name of the box. Names are always lowercase.
  Future<String?> get boxName async {
    try {
      await _openBox();
      return _box!.name;
    } catch (e) {
      return null;
    }
  }

  /// The location of the box in the file system.
  Future<String?> get path async {
    try {
      await _openBox();
      return _box!.path;
    } catch (e) {
      return null;
    }
  }

  /// All values in the box.
  Future<Iterable<ValueType>?> get values async {
    try {
      await _openBox();
      return _box!.values;
    } catch (e) {
      return null;
    }
  }

  /// Close the opened box.
  Future<void> closeBox() async => _box!.isOpen ? await _box!.close() : null;
}
