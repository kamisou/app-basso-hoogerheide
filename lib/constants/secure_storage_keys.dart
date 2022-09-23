class SecureStorageKey {
  const SecureStorageKey._(this.key);

  final String key;

  static const SecureStorageKey authToken = SecureStorageKey._('auth_token');
}
