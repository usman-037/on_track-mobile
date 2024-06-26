import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class LocalNotificationService {
  static final localNotification = FlutterLocalNotificationsPlugin();

  static Future<void> initialize()async{
    // configure android to use the app icon for notification
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // this function would be used for iOS apps when notification is received
    // it can be configured as needed.
    void onDidReceiveLocalNotification(
        int? id, String? title, String? body, String? payload) async {
      print('the notification arrived ');
    }

    // darwin settings is for iOS and MacOS
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // android and ios settings are thus embedded together
    final InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // initialize the plugin with the configured settings.
    await localNotification.initialize(
      settings,
    );

  }
}