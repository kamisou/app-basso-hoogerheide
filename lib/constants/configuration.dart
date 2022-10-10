import 'package:flutter_riverpod/flutter_riverpod.dart';

final configurationProvider =
    Provider.autoDispose((ref) => const Configuration());

class Configuration {
  const Configuration();

  final String restServerUrl = 'https://www.bassoadvogados.adv.br/api';

  final String calendarEventsMessagingTopic = 'calendar_events';
}
