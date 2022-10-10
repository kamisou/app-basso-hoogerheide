import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:basso_hoogerheide/interface/notifications.dart';
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
      final Map<String, dynamic> event = json.decode(message.data['event']);
      final String? action = message.data['action'];
      if (action == 'cancel' || action == 'edit') {
        await notifications.cancel(event['id']);
      }
      if (action == 'add' || action == 'edit') {
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
    switch (message.data['type']) {
      case 'event':
        final Map<String, dynamic> event = json.decode(message.data['event']);
        final String? action = message.data['action'];
        if (action == 'cancel' || action == 'edit') {
          await ref.read(notificationsProvider).cancelNotification(event['id']);
        }
        if (action == 'add' || action == 'edit') {
          await ref.read(notificationsProvider).scheduleNotification(
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

  Future<void> subscribeToTopic(String topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}
