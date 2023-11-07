// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/model.dart';
import 'package:todo/providers/selectedbox_provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/providers/time_provider.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/utilities/features.dart';
import 'package:todo/utilities/firebase_database.dart';
import 'package:todo/widgets/custom_widgets.dart'; // Add this import for the TimePicker

TextEditingController title = TextEditingController();
TextEditingController note = TextEditingController();
TextEditingController date = TextEditingController();
TextEditingController starttime = TextEditingController();
TextEditingController endtime = TextEditingController();
TextEditingController reminder = TextEditingController();

AdditionslFeature feature = AdditionslFeature();

final _formkey3 = GlobalKey<FormState>();

List<String> options = [
  '5 Minutes early',
  '10 Minutes early',
  '15 Minutes early',
  '30 Minutes early'
];

Future<void> Updatetask(String docId, BuildContext context) async {
  print("running program");
  if (_formkey3.currentState != null && _formkey3.currentState!.validate()) {
    NoteModel n = NoteModel(
      id: docId,
      title: title.text,
      note: note.text,
      date: date.text,
      starttime: starttime.text,
      endtime: endtime.text,
      reminder: reminder.text,
    );
    try {
      bool result = await FirebaseStore.Updatask(
          n, docId, FirebaseAuth.instance.currentUser!.uid);
      if (result == true) {
        // Navigator.of(context).pop();
        aftertrue(context);
      } else {
        // Navigator.of(context).pop();
        afterfalse(context);
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}

aftertrue(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => home_screen(),
      ));
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "Task Addes !",
      style: TextStyle(
          fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.black,
  ));
  // Navigator.of(context).pop();
}

afterfalse(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "Unable to Add Task !",
      style: TextStyle(
          fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.black,
  ));
  Navigator.of(context).pop();
}


Future<NoteModel?> GetTaskDetails(String docId) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Task")
        .doc(
            docId) // Use doc method instead of get for retrieving a specific document
        .get();

    if (!querySnapshot.exists) {
      print('No document found for the specified ID.');
      return null;
    }

    Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
    NoteModel task = NoteModel(
      id: docId,
      title: data['title'],
      note: data['note'],
      date: data['date'],
      starttime: data['starttime'],
      endtime: data['endtime'],
      reminder: data['reminder'],
      isCompleted: data['isCompleted'],
    );

    return task;
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}

void updatesheet(BuildContext context, String docId, String uid) async {
  GetTaskDetails(docId);
  NoteModel? task = await GetTaskDetails(docId);
  if (task != null) {
    title.text = task.title ?? '';
    note.text = task.note ?? '';
    date.text = task.date ?? '';
    starttime.text = task.starttime ?? '';
    endtime.text = task.endtime ?? '';
    reminder.text = task.reminder ?? '';
  }

  final timeProvider = Provider.of<TimeProvider>(context, listen: false);
  final provider = context.read<SelectedBoxProvider>();
  String datevalue = provider.getFormattedDate().toString();

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
                  "Update Task",
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
                    key: _formkey3,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: title,
                          sur: const Icon(Icons.note_add_outlined),
                          labelText: "Note Title",
                          hintText: "Eat Snacks",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Title can not be empty";
                            } else if (value.length < 3) {
                              return "It needs a minimum of 3 letters";
                            }
                            return null;
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
                          hintText: "I will eat chips with coke!",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Body can not be empty";
                            } else if (value.length < 3) {
                              return "It needs a minimum of 3 letters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: date,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Date',
                            suffixIcon: Icon(Icons.date_range),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Date can not be empty";
                            }
                            return null;
                          },
                        ),
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
                                          onSelectedTime: (TimeOfDay newTime) {
                                            final formattedTime = timeProvider
                                                .formatTime(newTime, context);
                                            timeProvider
                                                .updateStartTime(formattedTime);
                                            starttime.text =
                                                formattedTime; // Add this line
                                          },
                                        );
                                        timePicker.selectTime(context);
                                      },
                                      icon: const Icon(
                                          Icons.watch_later_outlined),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Start time can not be empty";
                                    }
                                    return null;
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
                                          onSelectedTime: (TimeOfDay newTime) {
                                            final formattedTime = timeProvider
                                                .formatTime(newTime, context);
                                            timeProvider
                                                .updateEndTime(formattedTime);
                                            endtime.text =
                                                formattedTime; // Add this line
                                          },
                                        );
                                        timePicker.selectTime(context);
                                      },
                                      icon: const Icon(
                                          Icons.watch_later_outlined),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "End time can not be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<String>(
                          value: reminder.text,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                            color:
                                Provider.of<ThemeProvider>(context).isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          onChanged: (String? newValue) {
                            // Update the dropdown value when the user selects an option
                            // setState(() {
                            //   reminder.text = newValue!;
                            // });
                          },
                          items: options.map((String value) {
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
                            hintText: "5 Minutes early ",
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomElevatedButton(
                            message: "Update Task",
                            function: () async {
                              if (_formkey3.currentState != null &&
                                  _formkey3.currentState!.validate()) {
                                await Updatetask(docId, context);
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
