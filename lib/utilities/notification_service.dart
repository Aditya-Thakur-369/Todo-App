// import 'dart:math';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future initNotification() async {

//     AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('launcher');

//     var initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (id, title, body, payload) async {},
//     );

//     InitializationSettings initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }

//   notificationsDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channelId 1',
//           'channelName 1',
//           playSound: true,
//           priority: Priority.high,
//           importance: Importance.max,
//           icon: 'launcher',
//           ticker: 'ticker',
//           enableVibration: true,
//           channelShowBadge: true,
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ));
//   }

//   Future shownotification(
//       {int id = 0, String? title, String? body, String? payload}) async {

//     try {
//       return _flutterLocalNotificationsPlugin.show(
//           id, title, body, await notificationsDetails());
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future scheduleNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     required DateTime datetime,
//     String? payload,
//   }) async {
//     try {
//       var scheduledTime = tz.TZDateTime.from(datetime, tz.local);
//       return _flutterLocalNotificationsPlugin.zonedSchedule(
//           id, title, body, scheduledTime, await notificationsDetails(),
//           payload: payload,
//            uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime);
//     } catch (e) {
//       print("The error is  : ----------------- $e");
//     }
//   }

//     cancelnotificaion() async {
//     await _flutterLocalNotificationsPlugin.cancelAll();
//   }
// }

import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
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
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId 1',
          'channelName 1',
          playSound: true,
          priority: Priority.high,
          importance: Importance.max,
          icon: 'launcher',
          ticker: 'ticker',
          enableVibration: true,
          channelShowBadge: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ));
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

  Future scheduleNotification({
    int id = 2,
    String? title,
    String? body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    try {
      // Check notification permissions
      var hasPermission = await checkNotificationPermission();
      if (!hasPermission) {
        // Request notification permission
        await Permission.notification.request();
      }

      // Convert scheduled time to local time zone
      var scheduledTimeLocal = tz.TZDateTime.from(scheduledTime, tz.local);

      // Schedule the notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
          id, title, body, scheduledTimeLocal, await notificationsDetails(),
          payload: payload,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  Future<void> scheduleNotifications(NoteModel task) async {
    if (task != null ) {
      print(task);
    } else {
      print("Task is empty ");
    }
    final DateTime taskStartTime = DateTime.parse(task.starttime ?? '');
    final DateTime now = DateTime.now();

    if (taskStartTime.isAfter(now)) {
      // Schedule notification only if task starttime is in the future
      int notificationId = task.id.hashCode; // Unique ID for each notification

      // Calculate the delay until the task starttime
      int delay = taskStartTime.difference(now).inSeconds;

      await Future.delayed(Duration(seconds: delay), () async {
        await initNotification();
        await showNotification(
          id: notificationId,
          title: 'Task Reminder',
          body: 'Your task "${task.title}" is scheduled to start now.',
        );
      });
    }
  }

  Future cancelNotification({int id = 0}) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
