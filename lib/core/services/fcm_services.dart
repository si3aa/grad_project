import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMServices {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission();
    final token = await firebaseMessaging.getToken();
    log('----------------------------------------- $token');

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(handleMessage);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleForegroundMessage(message);
    });
  }

  // Get FCM token for user login
  Future<String?> getFCMToken() async {
    try {
      await firebaseMessaging.requestPermission();
      final token = await firebaseMessaging.getToken();
      log('FCM Token: $token');
      return token;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  void handleForegroundMessage(RemoteMessage message) {
    log('-----------------------------------------');
    log('New message received while app is in foreground!');
    log('Message ID: ${message.messageId}');
    log('Message Type: ${message.messageType}');
    log('Message Data: ${message.data}');

    if (message.notification != null) {
      log('Notification Details:');
      log('Title: ${message.notification?.title}');
      log('Body: ${message.notification?.body}');
    }
  }
}

Future<void> handleMessage(RemoteMessage msg) async {
  log('------title : ${msg.notification?.title}');
  log('title : ${msg.notification?.body}');
}