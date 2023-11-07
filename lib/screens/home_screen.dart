import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/main.dart';
import 'package:todo/models/model.dart';
import 'package:todo/providers/dateTime_provider.dart';
import 'package:todo/providers/selectedbox_provider.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/screens/bottomsheet_addtask.dart';
import 'package:todo/screens/bottomsheet_updatetask.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/utilities/firebase_database.dart';
import 'package:todo/utilities/notification_service.dart';
import 'package:share_plus/share_plus.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  String? id;
  String? title;
  String? notebody;
  String? starttime;
  String? endtime;
  String? name;
  String? email;

  List<NoteModel> tasks = [];
  List<NoteModel> donetasks = [];

  List<Color> boxcolors = [
    Colors.deepPurple,
    const Color.fromARGB(255, 229, 91, 81),
    const Color.fromARGB(255, 61, 117, 63),
    const Color.fromARGB(255, 0, 137, 249),
    Colors.deepPurple,
    const Color.fromARGB(255, 229, 52, 111),
    Colors.purple,
    Colors.teal,
    Colors.deepOrange,
    Colors.deepPurple,
    const Color.fromARGB(255, 64, 77, 149)
  ];

  // Function to get the current date in a specific format

  // Function to get the current time in a specific format
  userinfo() async {
    try {
      Usermodel user = await FirebaseStore.userinfo();
      setState(() {
        name = user.name;
        email = user.email;
      });
    } catch (e) {
      // Handle the error here
      print("An error occurred: $e");
    }
    // print(del['email']);
  }

  Future<void> sign_out() async {
    FirebaseAuth.instance.signOut().then((value) async {
      var SharedPref = await SharedPreferences.getInstance();
      SharedPref.setBool(splash_screenState.KEYLOGIN, false);
      if (context.mounted) {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const signin_screen(),
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

  String formatDate(Map<String, dynamic>? dateMap) {
    if (dateMap == null) {
      return "";
    } else {
      String day = dateMap['date'].toString();
      String month = dateMap['month'];
      String year = dateMap['year'].toString();
      return "$day $month $year";
    }
  }

  checkmail() {
    bool emailverify = false;

    return emailverify = FirebaseAuth.instance.currentUser!.emailVerified;
  }

  @override
  void initState() {
    super.initState();
    userinfo();
    // getcurrentmonth();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final selectedBoxProvider = context.read<SelectedBoxProvider>();
      final datesProvider = context.read<DatesProvider>();
      final dates = DatesProvider();
      List<dynamic> dateList = dates.showDates();
      selectedBoxProvider.updateSelectedBox(dateList[0]);
      checkmail();
      todaydate();
      todaydonedate();
    });
  }

  void todaydate() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM y').format(now);

    tasks = await taskProvider.fetchTasks(formattedDate);
  }

  void todaydonedate() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM y').format(now);

    donetasks = await taskProvider.fetchdoneTasks(formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    // for checking mail is verified or not to change mail icon

    final selectedBoxProvider =
        Provider.of<SelectedBoxProvider>(context, listen: true);
    final selectedbox = selectedBoxProvider;
    final dateProvider = Provider.of<DatesProvider>(context, listen: true);
    final taskProvider = Provider.of<TaskProvider>(context);
    final dates = DatesProvider();
    List<dynamic> dateList = dates.showDates();
    final today = dateList[0];

    Map<String, dynamic>? selectedBoxValue = selectedBoxProvider.selectedBox;

    List<NoteModel> tasks = taskProvider.tasks;
    List<NoteModel> donetasks = taskProvider.completedtask;
    showtask() async {
      tasks =
          await taskProvider.fetchTasks(formatDate(selectedbox.selectedBox));
      donetasks = await taskProvider
          .fetchdoneTasks(formatDate(selectedbox.selectedBox));
    }

    showdonetask() async {
      donetasks = await taskProvider
          .fetchdoneTasks(formatDate(selectedbox.selectedBox));
      print(donetasks);
    }

    bool notificationOn = false;
    final screenwidth = MediaQuery.of(context).size.width;
    final screenhight = MediaQuery.of(context).size.height;
    final themeprovider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height / 12,
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            try {
                              NotificationService().shownotification(
                                body: "this is body",
                                title: "this is title",
                              );
                            } catch (e) {
                              print('e');
                            }

                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return CupertinoActionSheet(
                                  actions: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: screenhight / 1.9,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      FittedBox(
                                                          child: Text(
                                                        "$name",
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      FittedBox(
                                                          child: Text('$email ',
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .white,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none)))
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Change Theme',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Reminder',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                // Icon(
                                                //   Icons
                                                //       .notifications_active_outlined,
                                                //   color: Colors.white,
                                                // ),
                                                CupertinoSwitch(
                                                  value: notificationOn,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      notificationOn = value;
                                                    });
                                                  },
                                                  activeColor: Colors.purple,
                                                ),
                                              ],
                                            ),
                                            onPressed: () {},
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Email Verification',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Icon(
                                                  checkmail()
                                                      ? Icons
                                                          .mark_email_read_outlined
                                                      : Icons.email_outlined,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              if (checkmail() == true) {
                                                final scaffoldContext =
                                                    ScaffoldMessenger.of(
                                                        context);
                                                scaffoldContext.showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Your Mail is already Verified !",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                );
                                              } else {
                                                final scaffoldContext =
                                                    ScaffoldMessenger.of(
                                                        context);
                                                if (scaffoldContext != null) {
                                                  FirebaseStore
                                                          .SendMailVerification()
                                                      .then((value) {
                                                    scaffoldContext
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Mail Sent ! Please Check Your mail !",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                                    );
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Share App',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
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
                                                    'https://github.com/Aditya-Thakur-369/Todo-App',
                                                    subject:
                                                        'Github Link for This App');
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
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onPressed: () {
                                        sign_out();
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
                              },
                            );
                          },
                          child: const CircleAvatar(
                            minRadius: 25,
                            maxRadius: 25,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person_sharp,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // IconButton(
                        //     onPressed: () {
                        //       sign_out();
                        //     },
                        //     icon: const Icon(
                        //       Icons.logout_outlined,
                        //     ))
                      ],
                    ),
                    FittedBox(
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 130),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Hi, ",
                                  style: TextStyle(
                                    color: themeprovider.isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 2,
                                  ),
                                ),
                                TextSpan(
                                  text: "$name",
                                  style: TextStyle(
                                    color: themeprovider.isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Add this line to handle text overflow
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            themeprovider.toggleTheme();
                          },
                          icon: Icon(
                            themeprovider.getThemeIcon(),
                            size: 25,
                          )),
                    )
                  ]),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // get task bottom model sheet appear heer
                      selectedbox.getFormattedDate();
                      gettask(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 16,
                      width: MediaQuery.of(context).size.width / 3,
                      clipBehavior: Clip.none,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10, left: 8),
                        child: FittedBox(
                          child: Row(children: [
                            Text(
                              "Add Task",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Icon(
                              Icons.add,
                              size: 25,
                              color: Colors.white,
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    selectedbox.getFormattedDate(),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[650],
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Code Starts From here ------------------------

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dateList.length,
                itemBuilder: (context, index) {
                  final item = dateList[index];
                  final color = boxcolors[index % boxcolors.length];
                  final selectedBoxValue = selectedbox.selectedBox;

                  return Padding(
                    padding: const EdgeInsets.only(right: 5, left: 3),
                    child: GestureDetector(
                      onTap: () async {
                        selectedbox.updateSelectedBox(item);
                        showtask();
                        showdonetask();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.deepPurple.withOpacity(1)),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // Spread radius
                              blurRadius: 2, // Blur radius
                              offset: const Offset(0, 3), // Offset
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          // color: Colors.deepPurple
                          // color: color
                          color: selectedBoxValue != null &&
                                  selectedBoxValue['year'] == item['year'] &&
                                  selectedBoxValue['month'] == item['month'] &&
                                  selectedBoxValue['date'] == item['date'] &&
                                  selectedBoxValue['dayOfWeek'] ==
                                      item['dayOfWeek']
                              ? Colors.deepPurple
                              : Colors.deepPurple.withOpacity(0.4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FittedBox(
                                child: Text(
                                  item['month'] != null ? item['month'] : '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: themeprovider.isDarkMode
                                        ? Colors.white
                                        : Colors.white,
                                    // selectedbox == index
                                    // ? Colors.white
                                    // : Colors.white
                                  ),
                                ),
                              ),
                              Text(
                                item['date'] != null
                                    ? item['date'].toString()
                                    : '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,

                                  // selectedbox == index
                                  // ? Colors.white
                                  // : Colors.white
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  item['dayOfWeek'] != null
                                      ? item['dayOfWeek']
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    // selectedbox == index
                                    // ? Colors.white
                                    // : Colors.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Second Container Starts

          Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Colors.purple[200]!.withOpacity(1),
                    Colors.deepPurple.withOpacity(0.5)
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                width: MediaQuery.of(context).size.width,
                height: screenhight / 1.9,
                child: tasks.isNotEmpty && tasks != 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 5),
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final currentTask = tasks[index];

                            final color = boxcolors[index % boxcolors.length];

                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 5),
                              child: GestureDetector(
                                onTap: () {},
                                onLongPress: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        actions: [
                                          Material(
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: color),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          FittedBox(
                                                            child: Container(
                                                              constraints: BoxConstraints(
                                                                  maxWidth: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      100,
                                                                  maxHeight: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      8),
                                                              child:
                                                                  SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                child: Text(
                                                                  // "Title " + index.toString(),
                                                                  currentTask
                                                                          .title ??
                                                                      "",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .lock_clock,
                                                                size: 28,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Text(
                                                                // "    02:04 PM - 02:19 PM",
                                                                "    ${currentTask.starttime} - ${currentTask.endtime}",

                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          FittedBox(
                                                            child: Container(
                                                              constraints: BoxConstraints(
                                                                  maxWidth: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      100,
                                                                  maxHeight: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      10),
                                                              child:
                                                                  SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                child: Text(
                                                                  // "Note 1",
                                                                  currentTask
                                                                          .note ??
                                                                      "",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 1000,
                                                              width: 1,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            const RotatedBox(
                                                              quarterTurns:
                                                                  3, // Set the number of clockwise quarter turns
                                                              child: Text(
                                                                'TODO',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white,
                                                                ), // Define the text style
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text(
                                              "Mark as Done 🙂",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600),
                                            ),
                                            onPressed: () async {
                                              DateTime now = DateTime.now();

                                              // Format the time using DateFormat
                                              String formattedTime =
                                                  DateFormat('hh:mm a')
                                                      .format(now);
                                              bool rs = await FirebaseStore
                                                  .MarkasRead(
                                                      currentTask.id.toString(),
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      formattedTime);
                                              if (rs = true) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const home_screen(),
                                                    ));
                                                final scaffoldContext =
                                                    ScaffoldMessenger.of(
                                                        context);
                                                scaffoldContext.showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Task Done 👍🏻",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                );
                                              } else {
                                                print(
                                                    "Something is wrong while deleting the Task");
                                              }
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600),
                                            ),
                                            onPressed: () {
                                              updatesheet(
                                                  context,
                                                  currentTask.id.toString(),
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600),
                                            ),
                                            onPressed: () async {
                                              bool rs = await FirebaseStore
                                                  .DeleteTask(
                                                      currentTask.id.toString(),
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid);
                                              if (rs = true) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const home_screen(),
                                                    ));
                                                final scaffoldContext =
                                                    ScaffoldMessenger.of(
                                                        context);
                                                scaffoldContext.showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Task Deleted Successfully ! ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                );
                                              } else {
                                                print(
                                                    "Something is wrong while deleting the Task");
                                              }
                                            },
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                    height: 110,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: color),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FittedBox(
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              100),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      // "Title " + index.toString(),
                                                      currentTask.title ?? "",
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.lock_clock,
                                                    size: 28,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    // "    02:04 PM - 02:19 PM",
                                                    "    ${currentTask.starttime} - ${currentTask.endtime}",

                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              FittedBox(
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              100),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      // "Note 1",
                                                      currentTask.note ?? "",
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 1,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const RotatedBox(
                                                  quarterTurns:
                                                      3, // Set the number of clockwise quarter turns
                                                  child: Text(
                                                    'TODO',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ), // Define the text style
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: screenhight / 1.9,
                        child: Center(
                            child: FittedBox(
                          child: GestureDetector(
                            onTap: () {
                              gettask(context);
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/empty_todo.svg',
                                  height: 200,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Add Some Task To Increase Your Productivity !!",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ))),

                // second Container strts from here
              )),

          //  i want to show another list in sizedbox with same features and funtions only list is changes from task to donetask and all other things are same how can i do that , one more feature if donetask list is empty then it will srink but show the container

          const SizedBox(
            height: 10,
          ),
          donetasks.isNotEmpty && donetasks != 0
              ? Container(
                  height: 30,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ]),
                  child: const Center(
                    child: Text(
                      "Task Completed",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          const SizedBox(
            height: 20,
          ),
          donetasks.isNotEmpty && donetasks != 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [
                        Colors.purple[200]!.withOpacity(1),
                        Colors.deepPurple.withOpacity(0.5)
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: screenhight / 1.9,
                    child: donetasks.isNotEmpty && donetasks != 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 3, bottom: 3, right: 3, left: 3),
                            child: ListView.builder(
                              itemCount: donetasks.length,
                              itemBuilder: (context, index) {
                                final currentdoneTask = donetasks[index];
                                final color =
                                    boxcolors[index % boxcolors.length];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 5, right: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(currentdoneTask);
                                    },
                                    onLongPress: () {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoActionSheet(
                                            actions: [
                                              Material(
                                                child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: color),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              FittedBox(
                                                                child:
                                                                    Container(
                                                                  constraints: BoxConstraints(
                                                                      maxWidth:
                                                                          MediaQuery.of(context).size.width -
                                                                              100,
                                                                      maxHeight:
                                                                          MediaQuery.of(context).size.height /
                                                                              8),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Task Completed at : ",
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            // "    02:04 PM - 02:19 PM",
                                                                            currentdoneTask.completedTime ??
                                                                                '',

                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              "Title : ",
                                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                            ),
                                                                            Text(
                                                                              currentdoneTask.title ?? "",
                                                                              style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              FittedBox(
                                                                child:
                                                                    Container(
                                                                  constraints: BoxConstraints(
                                                                      maxWidth:
                                                                          MediaQuery.of(context).size.width -
                                                                              100,
                                                                      maxHeight:
                                                                          MediaQuery.of(context).size.height /
                                                                              10),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    child: Text(
                                                                      // "Note 1",
                                                                      currentdoneTask
                                                                              .note ??
                                                                          "",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Container(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: 1000,
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                const RotatedBox(
                                                                  quarterTurns:
                                                                      3, // Set the number of clockwise quarter turns
                                                                  child: Text(
                                                                    'TODO',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .white,
                                                                    ), // Define the text style
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              CupertinoActionSheetAction(
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                onPressed: () async {
                                                  bool rs = await FirebaseStore
                                                      .DeleteTask(
                                                          currentdoneTask.id
                                                              .toString(),
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid);
                                                  if (rs = true) {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const home_screen(),
                                                        ));
                                                    final scaffoldContext =
                                                        ScaffoldMessenger.of(
                                                            context);
                                                    scaffoldContext
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Task Deleted Successfully ! ",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                                    );
                                                  } else {
                                                    print(
                                                        "Something is wrong while deleting the Task");
                                                  }
                                                },
                                              ),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                        height: 110,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: color),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  FittedBox(
                                                    child: Container(
                                                      constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              100),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          // "Title " + index.toString(),
                                                          currentdoneTask
                                                                  .title ??
                                                              "",
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Task Completed at : ",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        // "    02:04 PM - 02:19 PM",
                                                        currentdoneTask
                                                                .completedTime ??
                                                            " ",

                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  FittedBox(
                                                    child: Container(
                                                      constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              100),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          // "Note 1",
                                                          currentdoneTask
                                                                  .note ??
                                                              "",
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 100,
                                                      width: 1,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    const RotatedBox(
                                                      quarterTurns:
                                                          3, // Set the number of clockwise quarter turns
                                                      child: Text(
                                                        'TODO',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                        ), // Define the text style
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),

                    // second Container strts from here
                  ))
              : SizedBox(),
        ]),
      )),
    );
  }
}
