import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'localnotification.dart';

Future<void> _backgroundMsgHandler(RemoteMessage? message) async {
  // Handle background message here
  print("Handling background message: $message");
}

class FirebaseMessagingService {
  static final FirebaseMessaging firebaseInstance = FirebaseMessaging.instance;

  static Future<void> init() async {
    /**
     * When the app is completely closed (not in the background)
     * and opened directly from the push notification
     */
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? event) {
      // Handle initial message here
      print("Handling initial message: $event");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Handle message when app is open
      print("Handling message when app is open: $message");
      // Show local notification
      await _showLocalNotification(message);
    });
    //Background
    FirebaseMessaging.onBackgroundMessage(_backgroundMsgHandler);

    /**
     * When the app is open and it receives a push notification
     */
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Handle message when app is open
      print("Handling message when app is open: $message");
    });

    /**
     * When the app is in the background and is opened directly
     * from the push notification.
     */
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle message when app is opened from background
      print("Handling message when app is opened from background: $message");
    });

  }

  // This function handles app permissions
  Future<void> grantAppPermission() async {
    NotificationSettings settings = await firebaseInstance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // Handle final permission settings from user as appropriate
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
Future<void> _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id', 'your_channel_name', channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await LocalNotificationService.localNotification.show(
    0, // Notification ID
    message.notification!.title, // Notification title
    message.notification!.body, // Notification body
    platformChannelSpecifics,
  );
}
