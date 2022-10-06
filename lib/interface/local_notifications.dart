import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:basso_hoogerheide/constants/configuration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localNotificationsProvider = Provider.autoDispose(
  (ref) => LocalNotifications(ref, channels: [
    LocalNotificationChannel(
      key: ref.read(configurationProvider).calendarNotificationChannelKey,
      title: null,
      description: null,
    ),
  ]),
);

final activeNotificationsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(localNotificationsProvider).getNotifications(),
);

class LocalNotifications {
  LocalNotifications(
    this.ref, {
    required this.channels,
  });

  final Ref ref;

  final List<LocalNotificationChannel> channels;

  final _notifications = AwesomeNotifications();

  Future<bool> initialize() => _notifications.initialize(
        null,
        channels
            .map((e) => NotificationChannel(
                  channelKey: e.key,
                  channelName: e.title,
                  channelDescription: e.description,
                ))
            .toList(),
      );

  Future<List<LocalNotification>> getNotifications() =>
      _notifications.listScheduledNotifications().then((value) => value
          .map((e) => LocalNotification(
                id: e.content!.id!,
                channelKey: e.content!.channelKey!,
                title: e.content!.title,
                body: e.content!.body,
              ))
          .toList());

  Future<void> addNotification(
    LocalNotification notification,
    DateTime scheduledDate,
  ) async =>
      _notifications.createNotification(
        content: NotificationContent(
          id: notification.id,
          channelKey: notification.channelKey,
          title: notification.title,
          body: notification.body,
        ),
        schedule: NotificationCalendar.fromDate(
          allowWhileIdle: true,
          date: scheduledDate,
        ),
      );
}

class LocalNotificationChannel {
  const LocalNotificationChannel({
    required this.key,
    required this.title,
    required this.description,
  });

  final String key;

  final String? title;

  final String? description;
}

class LocalNotification {
  const LocalNotification({
    required this.id,
    required this.channelKey,
    required this.title,
    required this.body,
  });

  final int id;

  final String channelKey;

  final String? title;

  final String? body;
}
