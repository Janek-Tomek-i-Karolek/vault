// Source - https://stackoverflow.com/a/77161015
// Posted by Tofiq Samali
// Retrieved 2026-05-21, License - CC BY-SA 4.0

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String> readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'NULL';
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    await storage.delete(key: key);
  }
}
