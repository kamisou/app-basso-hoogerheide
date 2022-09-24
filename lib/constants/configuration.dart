import 'package:flutter_riverpod/flutter_riverpod.dart';

final configurationProvider =
    Provider.autoDispose((ref) => const Configuration());

class Configuration {
  const Configuration();

  // TODO: apontar para servidor REST real
  final String restServerUrl = 'http://192.168.0.222:80/api';
}
