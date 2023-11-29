import 'dart:convert';

import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundNotification(RemoteMessage message) async {
  print('Title: ${message.notification!.title}');
  print('Title: ${message.notification!.body}');
}

class NotificationUtil {
 static final _firebaseMessaging = FirebaseMessaging.instance;

 static const _androidChannel =  AndroidNotificationChannel(
      'default_channel_id', 'App notification',
      description: 'Notification channel for app',
      importance: Importance.defaultImportance);

 static final _localNotification = FlutterLocalNotificationsPlugin();

 static void handleMessage(RemoteMessage? message) {
    
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(NOTIFICATION_PAGE, arguments: message);
  }

 static Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/ic_launcher')),
          payload: jsonEncode(message.toMap()));
    });
  }

 static Future initLocalNotifiaction() async {
    const iOS=DarwinInitializationSettings();
    const android=AndroidInitializationSettings('@drawable/ic_launcher');
    const settings=InitializationSettings(android: android, iOS: iOS);
    _localNotification.initialize(settings, onDidReceiveNotificationResponse: (details) {
      final message=RemoteMessage.fromMap(jsonDecode(details.payload.toString()));
      handleMessage(message);
    },);

    final platform=_localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform!.createNotificationChannel(_androidChannel);
  }

 static Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    initPushNotification();
    initLocalNotifiaction();
  }
}
