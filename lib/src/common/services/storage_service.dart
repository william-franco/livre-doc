import 'package:shared_preferences/shared_preferences.dart';

abstract interface class StorageService {
  Future<void> initStorage();
  Future<bool?> getBoolValue({required String key});
  Future<void> setBoolValue({required String key, required bool value});
  Future<String?> getStringValue({required String key});
  Future<void> setStringValue({required String key, required String value});
  Future<List<String>?> getStringListValue({required String key});
  Future<void> setStringListValue({
    required String key,
    required List<String> value,
  });
  Future<void> removeValue({required String key});
  Future<void> clearStorage();
}

class StorageServiceImpl implements StorageService {
  late final SharedPreferences _storage;

  @override
  Future<void> initStorage() async {
    try {
      _storage = await SharedPreferences.getInstance();
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }

  @override
  Future<bool?> getBoolValue({required String key}) async {
    try {
      return _storage.getBool(key);
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }

  @override
  Future<void> setBoolValue({required String key, required bool value}) async {
    try {
      await _storage.setBool(key, value);
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }

  @override
  Future<String?> getStringValue({required String key}) async {
    try {
      return _storage.getString(key);
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }

  @override
  Future<void> setStringValue({
    required String key,
    required String value,
  }) async {
    try {
      await _storage.setString(key, value);
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }

  @override
  Future<List<String>?> getStringListValue({required String key}) async {
    try {
      return _storage.getStringList(key);
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }

  @override
  Future<void> setStringListValue({
    required String key,
    required List<String> value,
  }) async {
    try {
      await _storage.setStringList(key, value);
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }

  @override
  Future<void> removeValue({required String key}) async {
    try {
      await _storage.remove(key);
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }

  @override
  Future<void> clearStorage() async {
    try {
      await _storage.clear();
    } catch (error) {
      throw Exception('StorageService: $error');
    }
  }
}
