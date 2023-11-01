import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/main.dart';
import 'package:todo/models/model.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/utilities/features.dart';
import 'package:todo/utilities/firebase_database.dart';
import 'package:todo/utilities/user_data.dart';
import 'package:todo/widgets/custom_widgets.dart';
import 'package:intl/intl.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  final _formkey = GlobalKey<FormState>();
// List of dropdown options
  List<String> options = [
    '5 Minutes early',
    '10 Minutes early',
    '15 Minutes early',
    '30 Minutes early'
  ];

  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController starttime = TextEditingController();
  TextEditingController endtime = TextEditingController();
  TextEditingController reminder = TextEditingController();

  String? name;
  String? email;

  int selectedbox = 0;
  List<int> numbers = List.generate(100, (index) => index + 1);

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
  getFormattedDate(DateTime dateTime) {
    var formatter = DateFormat('dd-MM-yyyy');
    print(formatter.format(dateTime));
    return formatter.format(dateTime);
  }

  // Function to get the current time in a specific format

  DateTime datenow = DateTime.now();
  TimeOfDay timenow = TimeOfDay.now();
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

  Future<dynamic> savetask() async {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      Navigator.pop(context);
      title.text = "";
      note.text = "";
      date.text = "";
      starttime.text = "";
      endtime.text = "";

      // FirebaseStore.Savetask(
      //   title: title.text,
      //   note: note.text,
      //   date: date.text,
      //   starttime: starttime.text,
      //   endtime: endtime.text,
      //   reminder: reminder.text,
      // );
      print("Done ");
      print(title.text);
      print(note.text);
      print(date.text);
      print(starttime.text);
      print(endtime.text);
      print(reminder.text);
    }
  }

  showoption() {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text("Mark as done ",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          color: Colors.grey.shade700,
                          decoration: TextDecoration.overline,
                        ))),
                Divider(
                  color: Colors.grey.shade800,
                  thickness: 0.5,
                  indent: 20,
                  endIndent: 20,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text("Edit ",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          color: Colors.grey.shade700,
                          decoration: TextDecoration.overline,
                        ))),
                Divider(
                  color: Colors.grey.shade800,
                  thickness: 0.5,
                  indent: 20,
                  endIndent: 20,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text("Delete ",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          color: Colors.grey.shade700,
                          decoration: TextDecoration.overline,
                        ))),
                Divider(
                  color: Colors.grey.shade800,
                  thickness: 0.5,
                  indent: 20,
                  endIndent: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel ",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          color: Colors.redAccent,
                          decoration: TextDecoration.overline,
                        )))
              ],
            ),
          ),
        );
      },
    );
  }

  gettask() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 6,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Add Task",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: title,
                            sur: const Icon(Icons.note_add_outlined),
                            labelText: "Note Title",
                            hintText: "Eat Snaks",
                            validator: (value) {
                              if (value == null && value!.isEmpty) {
                                return "Title can not be empty";
                              } else if (value.length < 3) {
                                return "It need minimum 3 letters";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: note,
                            sur: const Icon(
                              Icons.abc_outlined,
                              size: 30,
                            ),
                            labelText: "Note Body",
                            hintText: "I will eat chips with cock !",
                            validator: (value) {
                              if (value == null && value!.isEmpty) {
                                return "Body can not be empty";
                              } else if (value.length < 3) {
                                return "It need minimum 3 letters";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: date,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Date',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      DatePicker datePicker = DatePicker(
                                        labelText: 'Select Date',
                                        selectedDate: DateTime.now(),
                                        onSelectedDate: (DateTime newDate) {
                                          setState(() {
                                            date.text =
                                                getFormattedDate(newDate)
                                                    .toString();
                                            // date.text = newDate.toString();
                                          });
                                          print('Selected date: $newDate');
                                        },
                                      );
                                      datePicker.selectDate(context);
                                    },
                                    icon: Icon(Icons.date_range)),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return "Date can not be empty";
                                } else if (value.length < 2) {
                                  return "Date can not be empty";
                                } else {
                                  return null;
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  child: TextFormField(
                                    controller: starttime,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: "Start Time",
                                      hintText: "12:15",
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            TimePicker timePicker = TimePicker(
                                              labelText: 'Select Time',
                                              selectedTime: TimeOfDay.now(),
                                              onSelectedTime:
                                                  (TimeOfDay newTime) {
                                                print(
                                                    "time i showing  $newTime");
                                                setState(() {
                                                  starttime.text = Feature()
                                                      .getFormattedTime(
                                                          newTime);
                                                  print(starttime.text);
                                                });
                                                print(
                                                    'Selected time Dummy Time : $newTime');
                                              },
                                            );
                                            timePicker.selectTime(context);
                                          },
                                          icon: const Icon(
                                              Icons.watch_later_outlined)),
                                    ),
                                    validator: (value) {
                                      if (value == null && value!.isEmpty) {
                                        return "Start Time can not be empty";
                                      } else if (value.length < 2) {
                                        return "Start time can not be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  child: TextFormField(
                                    controller: endtime,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: "End Time",
                                      hintText: "12:45",
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            TimePicker timePicker = TimePicker(
                                              labelText: 'Select Time',
                                              selectedTime: TimeOfDay.now(),
                                              onSelectedTime:
                                                  (TimeOfDay newTime) {
                                                print(
                                                    "time i showing  $newTime");
                                                setState(() {
                                                  endtime.text = Feature()
                                                      .getFormattedTime(
                                                          newTime);
                                                  print(starttime.text);
                                                });
                                                print(
                                                    'Selected time Dummy Time : $newTime');
                                              },
                                            );
                                            timePicker.selectTime(context);
                                          },
                                          icon: const Icon(
                                              Icons.watch_later_outlined)),
                                    ),
                                    validator: (value) {
                                      if (value == null && value!.isEmpty) {
                                        return "End Time can not be empty";
                                      } else if (value.length < 2) {
                                        return "End time can not be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            value: reminder.text,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              // Update the dropdown value when the user selects an option
                              reminder.text = newValue!;
                            },
                            items: options
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Reminder',
                                hintText: "5 Minutes early "),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomElevatedButton(
                            message: "Add Task",
                            function: savetask,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // DateTimePicker(
                  //     labelText: "Time",
                  //     selectedDate: datenow,
                  //     selectedTime: timenow)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> sign_out() async {
    FirebaseAuth.instance.signOut().then((value) async {
      var SharedPref = await SharedPreferences.getInstance();
      SharedPref.setBool(splash_screenState.KEYLOGIN, false);
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
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    userinfo();
  }

  @override
  Widget build(BuildContext context) {
    reminder.text = '5 Minutes early';
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
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            )),
                        TextSpan(
                          text: "$name",
                          style: TextStyle(
                              color: themeprovider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
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
                      gettask();
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
                    "November 23, 2023 \nToday",
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
                itemCount: numbers.last,
                itemBuilder: (context, index) {
                  final color = boxcolors[index % boxcolors.length];

                  return Padding(
                    padding: const EdgeInsets.only(right: 5, left: 3),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedbox = index;
                          print(selectedbox);
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.deepPurple.withOpacity(1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(0, 3), // Offset
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            // color: Colors.deepPurple
                            // color: color
                            color: selectedbox == index
                                ? Colors.deepPurple
                                : Colors.transparent),
                        child: const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "AUG",
                                style: TextStyle(
                                  fontSize: 15,
                                  // selectedbox == index
                                  // ? Colors.white
                                  // : Colors.white
                                ),
                              ),
                              Text(
                                "23",
                                style: TextStyle(
                                  fontSize: 20,

                                  // selectedbox == index
                                  // ? Colors.white
                                  // : Colors.white
                                ),
                              ),
                              Text(
                                "WED",
                                style: TextStyle(
                                  fontSize: 25,
                                  // selectedbox == index
                                  // ? Colors.white
                                  // : Colors.white
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
                  final color = boxcolors[index % boxcolors.length];
                  
                  return index != null ?  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: GestureDetector(
                      onLongPress: () {
                        showoption();
                      },
                      child: Container(
                          height: 110,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: color),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Title 1",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.lock_clock,
                                          size: 28,
                                        ),
                                        Text("    02:04 PM - 02:19 PM"),
                                      ],
                                    ),
                                    Text(
                                      "Note 1",
                                      style: TextStyle(
                                          fontSize: 18,
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
                                              fontSize:
                                                  13), // Define the text style
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ) : Text("Empty");
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
