import 'package:flutter_riverpod/flutter_riverpod.dart';

final configurationProvider = Provider.autoDispose((ref) => const Configuration());

class Configuration {
  const Configuration();

  // TODO: apontar para servidor REST real
  final String restServerUrl =
      'https://fd7cb30e-821d-40a4-94c3-05612ef8ac3a.mock.pstmn.io';
}
