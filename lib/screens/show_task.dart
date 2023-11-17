import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo/models/model.dart';
import 'package:todo/providers/selectedbox_provider.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/screens/bottomsheet_addtask.dart';
import 'package:todo/screens/bottomsheet_updatetask.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/utilities/firebase_database.dart';

class ShowTask extends StatefulWidget {
  const ShowTask({super.key});

  @override
  State<ShowTask> createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
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

  List<NoteModel> tasks = [];

 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final selectedBoxProvider =
        Provider.of<SelectedBoxProvider>(context, listen: false);
    final selectedbox = selectedBoxProvider;
     showtask() async {
    final taskProvider = Provider.of<TaskProvider>(context);
    tasks = await taskProvider.fetchTasks(formatDate(selectedbox.selectedBox));
  }
  }
  

  @override
  Widget build(BuildContext context) {
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

    final screenwidth = MediaQuery.of(context).size.width;
    final screenhight = MediaQuery.of(context).size.height;
    return Padding(
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
                                                  BorderRadius.circular(10),
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
                                                            currentTask.title ??
                                                                "",
                                                            style: const TextStyle(
                                                                fontSize: 17,
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
                                                          Icons.lock_clock,
                                                          size: 28,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          // "    02:04 PM - 02:19 PM",
                                                          "    ${currentTask.starttime} - ${currentTask.endtime}",

                                                          style:
                                                              const TextStyle(
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
                                                            currentTask.note ??
                                                                "",
                                                            style: const TextStyle(
                                                                fontSize: 18,
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
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 1000,
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
                                            DateFormat('hh:mm a').format(now);
                                        bool rs =
                                            await FirebaseStore.MarkasRead(
                                                currentTask.id.toString(),
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                formattedTime);
                                        if (rs = true) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const home_screen(),
                                              ));
                                          final scaffoldContext =
                                              ScaffoldMessenger.of(context);
                                          scaffoldContext.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Task Done 👍🏻",
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
                                          print(
                                              "Something is wrong while deleting the Task");
                                        }
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        "Share Task",
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                      onPressed: () async {
                                        await Share.share(
                                            "🚀 Task Details 🚀\n\n"
                                            "📌 Task Title: ${currentTask.title}\n"
                                            "📋 Task Description: ${currentTask.note}\n"
                                            "📆 Task date: ${currentTask.date}\n"
                                            "⏰ Task Start Time: ${currentTask.starttime}\n"
                                            "⌛ Task End Time: ${currentTask.endtime}\n"
                                            "🚧 Task Status: In Progress\n\n"
                                            "📝 Dive into seamless task management with the cutting-edge Todo app!\n\n"
                                            "🌟 Discover the endless possibilities of the Todo app on GitHub. Let's simplify your task management journey together.\n"
                                            "GitHub Link: https://github.com/Aditya-Thakur-369/Todo-App",
                                            subject:
                                                "📅 Task Details from the Todo App 📝");
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
                                            FirebaseAuth
                                                .instance.currentUser!.uid);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                      onPressed: () async {
                                        bool rs =
                                            await FirebaseStore.DeleteTask(
                                                currentTask.id.toString(),
                                                FirebaseAuth
                                                    .instance.currentUser!.uid);
                                        if (rs = true) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const home_screen(),
                                              ));
                                          final scaffoldContext =
                                              ScaffoldMessenger.of(context);
                                          scaffoldContext.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Task Deleted Successfully ! ",
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
                                          print(
                                              "Something is wrong while deleting the Task");
                                        }
                                      },
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
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
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
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
        ));
  }
}
