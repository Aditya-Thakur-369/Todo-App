import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/model.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/utilities/firebase_database.dart';

class show_history extends StatefulWidget {
  const show_history({super.key});

  @override
  State<show_history> createState() => _show_historyState();
}

class _show_historyState extends State<show_history> {
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
    gethistory();
  }

  gethistory() async {
    List<NoteModel> fetchedTasks = await FirebaseStore.GetHistory();

    setState(() {
      tasks = fetchedTasks;
      tasks.sort((b, a) {
        final dateFormat = DateFormat("dd MMM yyyy");
        final dateA = dateFormat.parse(a.date!);
        final dateB = dateFormat.parse(b.date!);
        return dateA.compareTo(dateB);
      });
    });

    print(tasks);
  }

  @override
  Widget build(BuildContext context) {
    // final taskProvider = Provider.of<TaskProvider>(context);
    // List<NoteModel> tasks = taskProvider.gethistory;

    final themeprovider = Provider.of<ThemeProvider>(context);

    final screenwidth = MediaQuery.of(context).size.width;
    final screenhight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Task History"),
              actions: [
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
              ],
            ),
            body: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.2,
                // height: screenhight -100,
                child: tasks.isNotEmpty && tasks != 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 5),
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final currentTask = tasks[index];
                            iscomplete() {
                              if (currentTask.isCompleted == true) {
                                return " Task Completed at : ${currentTask.completedTime}  on ${currentTask.date}";
                              } else {
                                return "${currentTask.starttime} - ${currentTask.endtime} assigned on ${currentTask.date}";
                              }
                            }

                            final color = boxcolors[index % boxcolors.length];

                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 5),
                              child: GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoActionSheet(actions: [
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
                                                color: color,
                                              ),
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
                                                         Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                100,
                                                            maxHeight: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                10,
                                                          ),
                                                          child: ListView(
                                                            shrinkWrap: true,
                                                            children: [
                                                              Text(
                                                                currentTask
                                                                        .title ??
                                                                    "",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                     
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                100,
                                                            maxHeight: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                8,
                                                          ),
                                                          child: ListView(
                                                              shrinkWrap: true,
                                                              children: [
                                                                Text(
                                                                  iscomplete().toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    letterSpacing:
                                                                        2,
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                100,
                                                            maxHeight: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                10,
                                                          ),
                                                          child: ListView(
                                                            shrinkWrap: true,
                                                            children: [
                                                              Text(
                                                                currentTask
                                                                        .note ??
                                                                    "",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
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
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          const RotatedBox(
                                                            quarterTurns: 3,
                                                            child: Text(
                                                              'TODO',
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]);
                                      });
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
                                                      maxHeight: 30,
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
                                                    Icons.timelapse_outlined,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    // "    02:04 PM - 02:19 PM",
                                                    // ,
                                                    iscomplete().toString(),

                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              FittedBox(
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 30,
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
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: screenhight / 1.9,
                            child: Center(
                                child: FittedBox(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/empty_todo.svg',
                                    height: 200,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    " No Task History Found !",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    " Add Some Task To Increase Your Productivity !!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ))),
                      ),
              )
            ])));
  }
}
