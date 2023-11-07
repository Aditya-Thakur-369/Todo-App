import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initNotification() async {
    // Initialize the plugin on both Android and iOS
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationsDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            playSound: true,
            priority: Priority.high,
            importance: Importance.max,
            icon: 'launcher'),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ));
  }

  Future shownotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    // Initialize the plugin before calling shownotification()
    await initNotification();

    try {
      return _flutterLocalNotificationsPlugin.show(
          id, title, body, await notificationsDetails());
    } catch (e) {
      print(e);
    }
  }
}
