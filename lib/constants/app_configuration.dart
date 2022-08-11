import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider.autoDispose((_) => const AppConfiguration());

class AppConfiguration {
  const AppConfiguration();

  final String restApiServer = '';

  final String sessionTokenStorageKey = 'session_token';
}
