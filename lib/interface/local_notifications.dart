import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final localNotificationsProvider = Provider.autoDispose(LocalNotifications.new);

final activeNotificationsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(localNotificationsProvider).getNotifications(),
);

// TODO: implementar por completo (configurar initialize e as opções das plataformas)

class LocalNotifications {
  LocalNotifications(this.ref);

  final Ref ref;

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<bool?> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()),
    );
    return _localNotifications.initialize(const InitializationSettings());
  }

  Future<List<LocalNotification>> getNotifications() =>
      _localNotifications.getActiveNotifications().then((value) => value
          .map((e) => LocalNotification(
                id: e.id,
                title: e.title,
                body: e.body,
              ))
          .toList());

  Future<void> addNotification(
    LocalNotification notification,
    DateTime scheduledDate,
  ) =>
      _localNotifications.zonedSchedule(
        notification.id,
        notification.title,
        notification.body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
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
