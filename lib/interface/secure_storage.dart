import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = ChangeNotifierProvider((ref) => SecureStorage());

class SecureStorage extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String? value) =>
      _storage.write(key: key, value: value).then((_) => notifyListeners());

  Future<void> delete(String key) =>
      _storage.delete(key: key).then((_) => notifyListeners());
}
