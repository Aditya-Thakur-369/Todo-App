import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
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
      // routeInformationProvider: router.routeInformationProvider,
      // routeInformationParser: router.routeInformationParser,
      // routerDelegate: router.routerDelegate,
      home: splash_screen(),
    );
  }
}

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => splash_screenState();
}

class splash_screenState extends State<splash_screen> {
  static const String KEYLOGIN = 'login';

  void stateChage() async {
    var SharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = SharedPref.getBool(KEYLOGIN);

    Timer(Duration(seconds: 3), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          // context.go('/home_screen');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => home_screen(),
              ));
        } else {
          // context.go('/signin_screen');
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => signin_screen(),
              ));
        }
      } else {
        // context.go('/signin_screen');
         Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => signin_screen(),
              ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    stateChage();
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
                SvgPicture.asset('assets/images/splash.svg'),
                Text("Make You Work Easier !!")
              ],
            )),
      ),
    );
  }
}
