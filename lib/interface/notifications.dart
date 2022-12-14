import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ScheduledNotifications = Map<int, LocalNotification>;

final notificationsProvider = Provider.autoDispose(Notifications.new);

final scheduledNotificationsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(notificationsProvider).getNotifications(),
);

class Notifications {
  Notifications(this.ref);

  final Ref ref;

  final _notifications = AwesomeNotifications();

  Future<bool> initialize() => _notifications.initialize(
        'resource://drawable/notification.png',
        [
          NotificationChannel(
            channelKey: 'default',
            channelName: null,
            channelDescription: null,
          ),
        ],
      );

  Future<ScheduledNotifications> getNotifications() async {
    log('getNotifications');
    final List<LocalNotification> scheduled =
        await _notifications.listScheduledNotifications().then((value) => value
            .map((e) => LocalNotification(
                  id: e.content!.id!,
                  title: e.content!.title,
                  body: e.content!.body,
                ))
            .toList());
    final ScheduledNotifications notifications = {};
    for (final notification in scheduled) {
      notifications[notification.id] = notification;
    }
    return notifications;
  }

  void showNotification(LocalNotification notification) =>
      _notifications.createNotification(
        content: NotificationContent(
          id: notification.id,
          channelKey: 'default',
          title: notification.title,
          body: notification.body,
        ),
      );

  Future<void> scheduleNotification(
    LocalNotification notification,
    DateTime scheduledDate,
  ) async {
    log('addNotification ${notification.id}');
    return _notifications
        .createNotification(
          content: NotificationContent(
            id: notification.id,
            channelKey: 'default',
            title: notification.title,
            body: notification.body,
          ),
          schedule: NotificationCalendar.fromDate(
            allowWhileIdle: true,
            date: scheduledDate,
          ),
        )
        .then((_) => ref.refresh(scheduledNotificationsProvider));
  }

  Future<void> cancelNotification(int id) {
    log('cancelNotification $id');
    return _notifications.cancel(id);
  }

  Future<void> removeNotification(int id) {
    log('removeNotification $id');
    return _notifications
        .cancel(id)
        .then((_) => ref.refresh(scheduledNotificationsProvider));
  }
}

class LocalNotification {
  const LocalNotification({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;

  final String? title;

  final String? body;
}
