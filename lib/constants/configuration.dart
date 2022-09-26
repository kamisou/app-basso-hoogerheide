import 'package:flutter_riverpod/flutter_riverpod.dart';

final configurationProvider =
    Provider.autoDispose((ref) => const Configuration());

class Configuration {
  const Configuration();

  // TODO: apontar para servidor REST real
  final String restServerUrl = 'http://179.211.57.56:8080/api';
}
