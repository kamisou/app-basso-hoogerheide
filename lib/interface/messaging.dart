import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingProvider = Provider.autoDispose(Messaging.new);

class Messaging {
  Messaging(this.ref);

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

    FirebaseMessaging.instance.getToken().then((value) => log(value ?? ''));

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    return true;
  }

  Future<void> subscribeToTopic(String topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);

  void _onMessage(RemoteMessage message) {}

  static Future<void> _onBackgroundMessage(RemoteMessage message) async {}
}
