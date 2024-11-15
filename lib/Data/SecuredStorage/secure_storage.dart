import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:media_flow/Models/enum/secure_torage_keys.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveSecureData(SecureStorageKey key, String value) async {
    await storage.write(key: key.toString(), value: value);
  }

  Future<String?> readSecureData(SecureStorageKey key) async {
    final value = await storage.read(key: key.toString());
    if (value == null) return null;
   return value;
  }

  Future<void> deleteData(SecureStorageKey key) async {
    await storage.delete(key: key.toString());
  }
}