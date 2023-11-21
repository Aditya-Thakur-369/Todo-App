import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/models/model.dart';

class NotificationService {
  Future<bool> checkNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    } else {
      // Request notification permission
      await Permission.notification.request();
      return await Permission.notification.status.isGranted;
    }
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initNotification() async {
    // Create a notification channel for Android devices
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationsDetails() {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails('channelId 1', 'channelName 1',
          playSound: true,
          priority: Priority.high,
          importance: Importance.max,
          icon: 'launcher',
          ticker: 'ticker',
          enableVibration: true,
          channelShowBadge: true // Set this line
          ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    return platformChannelSpecifics;
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    try {
      return _flutterLocalNotificationsPlugin.show(
          id, title, body, await notificationsDetails());
    } catch (e) {
      print(e);
    }
  }

  int hashString(String? s) {
    // You can use a more sophisticated hash function if needed
    return s?.hashCode ?? 0;
  }

  Future scheduleNotification(NoteModel task) async {
    try {
      // Check notification permissions
      var hasPermission = await checkNotificationPermission();
      if (!hasPermission) {
        // Request notification permission
        await Permission.notification.request();
      }

      // Format scheduled time string to create a DateTime object
      DateTime scheduledTime = DateFormat("dd MMM yyyy hh:mm a").parse(
        '${task.date} ${task.starttime}',
      );

      // Convert scheduled time to local time zone
      var scheduledTimeLocal = tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      );

      // Use the hash function to convert the String? ID to an int
      int notificationId = hashString(task.id);

      print(
          "Time: ------------ ${scheduledTimeLocal} and task id : ${task.id}");

      // Schedule the notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, // Use the hash code as the notification ID
        task.title,
        task.note,
        scheduledTimeLocal,
        await notificationsDetails(),
        payload:
            task.id, // Use task ID as payload, you can change this as needed
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print("Here is task ID: ${notificationId}");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  Future cancelNotification({int id = 0}) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    
  }

  Future cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
