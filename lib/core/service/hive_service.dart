import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Open a box (if not already opened)
  static Future<Box> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    } else {
      return Hive.box(boxName);
    }
  }

  /// Save data to a specific box
  static Future<void> saveData({
    required String boxName,
    required String key,
    required dynamic value,
  }) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  /// Get data from a specific box
  static Future<T?> getData<T>({
    required String boxName,
    required String key,
  }) async {
    final box = await openBox(boxName);
    return box.get(key) as T?;
  }

  /// Delete data from a specific box
  static Future<void> deleteData({
    required String boxName,
    required String key,
  }) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  /// Clear all data in a specific box
  static Future<void> clearBox(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }

  /// Check if a key exists in a specific box
  static Future<bool> containsKey({
    required String boxName,
    required String key,
  }) async {
    final box = await openBox(boxName);
    return box.containsKey(key);
  }

  /// Close a box
  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }
}
