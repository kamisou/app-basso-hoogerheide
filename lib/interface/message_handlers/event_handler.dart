import 'dart:convert';

import 'package:basso_hoogerheide/interface/message_handlers/message_handler.dart';
import 'package:basso_hoogerheide/interface/notifications.dart';
import 'package:basso_hoogerheide/repositories/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventMessageHandlerProvider = Provider(EventMessageHandler.new);

class EventMessageHandler extends MessageHandler {
  const EventMessageHandler(this.ref);

  final Ref ref;

  static Future<void> onBackgroundMessage(
    Notifications notifications,
    RemoteMessage message,
  ) =>
      _scheduleEvent(notifications, message);

  static Future<void> _scheduleEvent(
    Notifications notifications,
    RemoteMessage message,
  ) async {
    final String? action = message.data['action'];
    if (action == 'add') return;

    final Map<String, dynamic> event = json.decode(message.data['event']);

    await notifications.cancelNotification(event['id']);

    if (action == 'edit') {
      await notifications.scheduleNotification(
        LocalNotification(
          id: event['id'],
          title: event['title'],
          body: event['description'],
        ),
        DateTime.parse(event['start']),
      );
    }
  }

  @override
  Future<void> onMessage(RemoteMessage message) async {
    final Notifications notifications = ref.read(notificationsProvider);

    _scheduleEvent(notifications, message);

    if (ref.read(appUserProvider).value!.id !=
        int.parse(message.data['author_id'])) {
      notifications.showNotification(
        LocalNotification(
          id: message.hashCode,
          title: message.notification?.title,
          body: message.notification?.body,
        ),
      );
    }
  }
}
