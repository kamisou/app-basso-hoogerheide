import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storageProvider = ChangeNotifierProvider((_) => EncryptedStorage());

class EncryptedStorage extends ChangeNotifier {
  EncryptedStorage();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Map<String, String?> _map = {};

  Future<void> initialize() async {
    _map = await _storage.readAll();
  }

  String? read(String key) => _map[key];

  Future<void> write(String key, String value) {
    _map[key] = value;
    return _storage.write(key: key, value: value);
  }
}
