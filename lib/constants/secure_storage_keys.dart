class SecureStorageKey {
  const SecureStorageKey(this.key);

  final String key;

  static const SecureStorageKey authToken = SecureStorageKey('auth_token');
}
