class SecureStorageKey {
  const SecureStorageKey._(this.key);

  final String key;

  static const String authToken = 'auth_token';

  static const String messagingToken = 'messaging_token';
}
