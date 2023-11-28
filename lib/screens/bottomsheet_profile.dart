import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/main.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/screens/show_history.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/utilities/firebase_database.dart';
import 'package:todo/utilities/notification_service.dart';

Future<void> sign_out(BuildContext context) async {
  FirebaseAuth.instance.signOut().then((value) async {
    var SharedPref = await SharedPreferences.getInstance();
    SharedPref.setBool(splash_screenState.KEYLOGIN, false);
    if (context.mounted) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                signin_screen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ));
    }
    // context.go('/signin_screen');
  });
}

bool emailverify = false;
checkmail() {
  var currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    emailverify = currentUser.emailVerified;
    return emailverify;
  } else {
    // Handle the case where currentUser is null, e.g., user not signed in
    return false;
  }
}

showOptions(BuildContext context, String name, String email) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return MyCupertinoActionSheet(name: name, email: email);
    },
  );
}

class MyCupertinoActionSheet extends StatefulWidget {
  final String name;
  final String email;

  MyCupertinoActionSheet({required this.name, required this.email});

  @override
  _MyCupertinoActionSheetState createState() => _MyCupertinoActionSheetState();
}

class _MyCupertinoActionSheetState extends State<MyCupertinoActionSheet> {
  bool notification = true;

  @override
  void initState() {
    super.initState();
    loadNotificationState();
  }

  void loadNotificationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notification = prefs.getBool('notification') ?? true;
    });
  }

  void saveNotificationState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', value);
  }

  void onNotificationChanged(bool value) {
    setState(() {
      notification = value;
      saveNotificationState(value);
      setState(() {
        NotificationService().resumeNotifications();
      });
      if (!notification) {
        setState(() {
          NotificationService().pauseNotifications();
        });
      }
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenhight = MediaQuery.of(context).size.height;
    final themeprovider = Provider.of<ThemeProvider>(context, listen: false);
    return CupertinoActionSheet(
      actions: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      minRadius: 50,
                      maxRadius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person_sharp,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                              child: Text(
                            "${widget.name}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                decoration: TextDecoration.none),
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                              child: Text('${widget.email} ',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      decoration: TextDecoration.none)))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Change Theme',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    Icon(
                      themeprovider.getThemeIcon(),
                      size: 25,
                      color: Colors.white,
                    )
                  ],
                ),
                onPressed: () {
                  themeprovider.toggleTheme();
                },
              ),
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reminder',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    CupertinoSwitch(
                      value: notification,
                      onChanged: onNotificationChanged,
                      activeColor: Colors.purple,
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Email Verification',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    Icon(
                      checkmail()
                          ? Icons.mark_email_read_outlined
                          : Icons.email_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (checkmail() == true) {
                    final scaffoldContext = ScaffoldMessenger.of(context);
                    scaffoldContext.showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Your Mail is already Verified !",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else {
                    final scaffoldContext = ScaffoldMessenger.of(context);
                    if (scaffoldContext != null) {
                      FirebaseStore.SendMailVerification().then((value) {
                        scaffoldContext.showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Mail Sent ! Please Check Your mail !",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.black,
                          ),
                        );
                      });
                    }
                  }
                },
              ),
              CupertinoActionSheetAction(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Task History',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    Icon(
                      Icons.history_edu_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => show_history(),
                      ));
                },
              ),
              CupertinoActionSheetAction(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Share App',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    Icon(
                      Icons.ios_share_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
                onPressed: () async {
                  try {
                    await Share.share(
                        '🚀 Stay organized with the Todo App! 📝📅⏰\n\n'
                        '🌟 Dive into seamless task management and get timely reminders!\n\n'
                        '📱 Download the Todo App now and simplify your daily routines!\n'
                        '🔗 GitHub Link: https://github.com/Aditya-Thakur-369/Todo-App\n\n'
                        '🔥 Be a productivity champion with the Todo App today! 🔥',
                        subject: '⭐ Your Perfect Task Management Companion ⭐');
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          child: const Text(
            'Sign Out',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          onPressed: () {
            sign_out(context);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.red),
          )),
    );
  }
}
