import 'dart:convert';

import 'package:basso_hoogerheide/interface/notifications.dart';
import 'package:basso_hoogerheide/repositories/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingProvider = Provider.autoDispose(Messaging.new);

Future<void> _onBackgroundMessage(RemoteMessage message) async {
  final notifications = Notifications(null);
  await notifications.initialize();
  _handleMessage(notifications, message);
}

void _handleMessage(Notifications notifications, RemoteMessage message) async {
  switch (message.data['type']) {
    case 'event':
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
}

class Messaging {
  const Messaging(this.ref);

  final Ref ref;

  Future<bool> initialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();

    final List<AuthorizationStatus> authorizationStatus = [
      AuthorizationStatus.authorized,
      AuthorizationStatus.provisional,
    ];

    if (!authorizationStatus.contains(settings.authorizationStatus)) {
      settings = await FirebaseMessaging.instance.requestPermission();
    }
    if (!authorizationStatus.contains(settings.authorizationStatus)) {
      return false;
    }

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    return true;
  }

  Future<String?> getInitialMessageType() async {
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message == null) return null;
    return message.data['type'];
  }

  Future<void> _onMessage(RemoteMessage message) async {
    final notifications = ref.read(notificationsProvider);

    _handleMessage(notifications, message);

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

  Future<void> subscribeToTopic(String topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}
