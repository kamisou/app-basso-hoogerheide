import 'package:firebase_messaging/firebase_messaging.dart';

abstract class MessageHandler {
  const MessageHandler();

  Future<void> onMessage(RemoteMessage message);
}