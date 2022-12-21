import 'package:basso_hoogerheide/interface/message_handlers/event_handler.dart';
import 'package:basso_hoogerheide/interface/message_handlers/message_handler.dart';
import 'package:basso_hoogerheide/interface/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingProvider = Provider.autoDispose(Messaging.new);

class Messaging {
  static const Map<String, Function(Notifications, RemoteMessage)>
      _backgroundHandlers = {
    'events': EventMessageHandler.onBackgroundMessage,
  };

  Messaging(this.ref);

  final Ref ref;

  final Map<String, Function(RemoteMessage)> _messageHandlers = {};

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

  void _onMessage(RemoteMessage message) =>
      _messageHandlers[message.from]?.call(message);

  Future<void> _onBackgroundMessage(RemoteMessage message) async {
    final notifications = Notifications(null);
    await notifications.initialize();
    _backgroundHandlers[message.from]?.call(notifications, message);
  }

  Future<void> subscribeToTopic(String topic, MessageHandler handler) {
    _messageHandlers[topic] = handler.onMessage;
    return FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) {
    _messageHandlers.remove(topic);
    return FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
