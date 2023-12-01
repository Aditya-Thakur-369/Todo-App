import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/providers/dateTime_provider.dart';
import 'package:todo/providers/selectedbox_provider.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/providers/time_provider.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/utilities/notification_service.dart';
import 'firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  await NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DatesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedBoxProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TimeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeprovider.getTheme(),
      home: const splash_screen(),
    );
  }
}

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => splash_screenState();
}

class splash_screenState extends State<splash_screen> {

  

  Future<bool> requestExactAlarmsPermission() async {
  if ( TargetPlatform.android == defaultTargetPlatform || TargetPlatform.iOS == defaultTargetPlatform) {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print('Notification permission granted.');
      return true;
    } else if (status.isDenied) {
      print('Notification permission denied.');
      
      return false;
    } else if (status.isPermanentlyDenied) {
      print('Notification permission permanently denied.');
      openAppSettings();
      return false;
    } else if (status.isLimited) {
      print('Notification permission is limited.');
      return false;
    } else if (status.isPermanentlyDenied) {
  print('Notification permission permanently denied.');
  openAppSettings();
  return false;
}
  }
  return false;
}

Future<bool> requestNotificationPermission() async {
  if (TargetPlatform.android == defaultTargetPlatform || TargetPlatform.iOS == defaultTargetPlatform) {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      print('Notification permission granted.');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationPermissionGranted', true);
      return true;
    } else if (status.isDenied) {
      print('Notification permission denied.');
      return false;
    } else if (status.isPermanentlyDenied) {
      print('Notification permission permanently denied.');
      openNotificationSettings();
      return false;
    } else if (status.isLimited) {
      print('Notification permission is limited.');
      return false;
    }
  }
  return false;
}


void openNotificationSettings() async {
  final String settingsUrl = 'app-settings:';
  if (await canLaunch(settingsUrl)) {
    await launch(settingsUrl);
  } else {
    print('Could not open app settings. Please open settings manually.');
  }
}

  static const String KEYLOGIN = 'login';

  void stateChage() async {
    var SharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = SharedPref.getBool(KEYLOGIN);

    Timer(const Duration(seconds: 3), () async {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const home_screen(),
              ));
        } else {
          await _flutterLocalNotificationsPlugin.cancelAll();
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const signin_screen(),
                ));
          }
        }
      } else {
        await _flutterLocalNotificationsPlugin.cancelAll();
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const signin_screen(),
                ));
          }
      }
    });
  }

  Future<void> _init() async {
    bool notificationPermission = await requestNotificationPermission();
    bool exactAlarmPermission = await requestExactAlarmsPermission();

    print('Notification Permission: $notificationPermission');
    print('Exact Alarm Permission: $exactAlarmPermission');

    stateChage();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Ensure vertical centering
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Image.asset('assets/images/splash_logo.png')),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Manage Your Day !!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                )
              ],
            )),
      ),
    );
  }
}
