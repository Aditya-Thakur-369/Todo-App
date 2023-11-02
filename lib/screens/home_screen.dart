import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/main.dart';
import 'package:todo/models/model.dart';
import 'package:todo/providers/dateTime_provider.dart';
import 'package:todo/providers/selectedbox_provider.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/screens/bottomsheet_addtask.dart';
import 'package:todo/screens/bottomsheet_addtask.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/utilities/firebase_database.dart';

import 'bottomsheet_addtask.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  String? title;
  String? notebody;
  String? starttime;
  String? endtime;
// List of dropdown options

  String? name;
  String? email;

  List<int> numbers = List.generate(100, (index) => index + 1);
  List<NoteModel> tasks = [];

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
    });
  }

  getcurrentmonth() {}
  String formatDate(Map<String, dynamic> dateMap) {
    String day = dateMap['date'].toString();
    String month = dateMap['month'];
    String year = dateMap['year'].toString();
    return "$day $month $year";
  }

  @override
  void initState() {
    super.initState();
    userinfo();
    getcurrentmonth();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final selectedBoxProvider = context.read<SelectedBoxProvider>();
      final datesProvider = context.read<DatesProvider>();
      final dates = DatesProvider();
      List<dynamic> dateList = dates.showDates();
      selectedBoxProvider
          .updateSelectedBox(dateList[0]); // Set the initial value

      // print(formatDate(selectedBoxProvider.selectedBox));
      // FirebaseStore.GetTask(formatDate(selectedBoxProvider.selectedBox));
    });
    // Dates dateTime = Dates();
    // List<dynamic> dates = dateTime.Calender();
    // print(dates);
  }

  @override
  Widget build(BuildContext context) {
    final selectedBoxProvider = context.read<SelectedBoxProvider>();
    final selectedbox = Provider.of<SelectedBoxProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final dateProvider = Provider.of<DatesProvider>(context);
    final dates = DatesProvider();
    List<dynamic> dateList = dates.showDates();
    final today = dateList[0];

    Future<String> getcurrentmonth() async {
      if (today['month'] == "Jan") {
        return "January";
      } else if (today['month'] == "Feb") {
        return "February";
      } else if (today['month'] == "Mar") {
        return "March";
      } else if (today['month'] == "Apr") {
        return "April";
      } else if (today['month'] == "May") {
        return "May";
      } else if (today['month'] == "Jun") {
        return "June";
      } else if (today['month'] == "Jul") {
        return "July";
      } else if (today['month'] == "Aug") {
        return "August";
      } else if (today['month'] == "Sep") {
        return "September";
      } else if (today['month'] == "Oct") {
        return "October";
      } else if (today['month'] == "Nov") {
        return "November";
      } else if (today['month'] == "Dec") {
        return "December";
      } else {
        return "Something Went Wrong";
      }
    }

    final screenwidth = MediaQuery.of(context).size.width;
    final screenhight = MediaQuery.of(context).size.height;
    final themeprovider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
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
                        const CircleAvatar(
                          minRadius: 25,
                          maxRadius: 25,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person_sharp,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              sign_out();
                            },
                            icon: const Icon(
                              Icons.logout_outlined,
                            ))
                      ],
                    ),
                    FittedBox(
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Hi, ",
                            style: TextStyle(
                              color: themeprovider.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 18,
                              letterSpacing: 2,
                            )),
                        TextSpan(
                          text: "$name",
                          style: TextStyle(
                              color: themeprovider.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w200),
                        ),
                      ])),
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
                    // gettoday,
                    selectedbox.getFormattedDate(),
                    // getcurrentmonth() +
                    //     ' ' +
                    //     today['date'].toString() +
                    //     ' , ' +
                    //     today['year'].toString() +
                    //     '\n' +
                    //     "Today",
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
                      onTap: () {
                        selectedbox.updateSelectedBox(item);
                        // void showTasks() async {
                        //   await taskProvider
                        //       .fetchTasks(formatDate(selectedbox.selectedBox));
                        // }
                        FirebaseStore.GetTask(
                                formatDate(selectedbox.selectedBox))
                            .then((notes) {
                          if (notes.isNotEmpty) {
                            tasks = notes;
                            for (var note in notes) {
                              print("Title: ${note.title}");
                              print("Note: ${note.note}");
                              print("Date: ${note.date}");
                              print("Start Time: ${note.starttime}");
                              print("End Time: ${note.endtime}");
                              print("Reminder: ${note.reminder}");
                              print("Is Completed: ${note.isCompleted}");
                              // setState(() {
                              //   title = "${note.title}";
                              //   notebody = "${note.note}";
                              //   starttime = "${note.starttime}";
                              //   endtime = "${note.endtime}";
                              // });
                            }
                          } else {
                            print('No documents found for the specified date.');
                          }
                        });
                        // print(selectedbox.selectedBox);
                        // print(formatDate(selectedbox.selectedBox));
                        // print(selectedbox);
                        // print(item);
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
                                style: TextStyle(
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
                                  style: TextStyle(
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: screenhight / 1.9,
              child: ListView.builder(
                itemCount: numbers.last,
                itemBuilder: (context, index) {
                  // final currentTask = tasks[index];
                  final color = boxcolors[index % boxcolors.length];

                  return index != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: GestureDetector(
                            onTap: () {
                              // print(taskProvider.tasks);
                            },
                            onLongPress: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return CupertinoActionSheet(
                                    actions: [
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          "Mark as Done 🙂",
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        ),
                                        onPressed: () {},
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        ),
                                        onPressed: () {},
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        ),
                                        onPressed: () {},
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Material(
                              child: Container(
                                  height: 110,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                            Text(
                                              "Title " + index.toString(),
                                              // currentTask.title,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.lock_clock,
                                                  size: 28,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "    02:04 PM - 02:19 PM",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Note 1",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
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
                          ),
                        )
                      : Text("Empty");
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}

// showcupotinomodelpopup
// CupertinoActionSheet
