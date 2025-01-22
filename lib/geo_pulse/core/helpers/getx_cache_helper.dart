// Objectives: This file is responsible for providing a helper class that is used to cache data in the app (shared preferences).
import 'package:get_storage/get_storage.dart';

abstract class GetXCacheHelper {
  static final GetStorage storage = GetStorage();

  static init() async {
    await GetStorage.init();
  }

  static dynamic getData({
    required String key,
  }) {
    return storage.read(key);
  }

  static Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
    return await storage.write(key, value);
  }

  static Future<void> removeData({
    required String key,
  }) async {
    return await storage.remove(key);
  }
}
