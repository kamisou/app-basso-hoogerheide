import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:basso_hoogerheide/interface/notifications.dart';
import 'package:basso_hoogerheide/models/repository/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingProvider = Provider.autoDispose(Messaging.new);

// TODO: ache uma maneira mais elegante para lidar com as notificações que não seja hardcoded

Future<void> onBackgroundMessage(RemoteMessage message) async {
  final notifications = AwesomeNotifications();
  notifications.initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'default',
        channelName: null,
        channelDescription: null,
      ),
    ],
  );
  switch (message.data['type']) {
    case 'event':
      final String? action = message.data['action'];
      if (action == 'add') return;

      final Map<String, dynamic> event = json.decode(message.data['event']);

      await notifications.cancel(event['id']);

      if (action == 'edit') {
        await notifications.createNotification(
          content: NotificationContent(
            id: event['id'],
            channelKey: 'default',
            title: event['title'],
            body: event['description'],
          ),
          schedule: NotificationCalendar.fromDate(
            date: DateTime.parse(event['start']),
          ),
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

    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    return true;
  }

  Future<void> onMessage(RemoteMessage message) async {
    final notifications = ref.read(notificationsProvider);

    switch (message.data['type']) {
      case 'event':
        final String? action = message.data['action'];
        if (action == 'add') break;

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
