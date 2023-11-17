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

@override
void dispose() {
  title.dispose();
  note.dispose();
  date.dispose();
  starttime.dispose();
  endtime.dispose();
  reminder.dispose();
}

AdditionslFeature feature = AdditionslFeature();

List<String> options = [
  '5 Minutes early',
  '10 Minutes early',
  '15 Minutes early',
  '30 Minutes early'
];

aftertrue(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const home_screen(),
      ));
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text(
      "Task Addes !",
      style: TextStyle(
          fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.black,
  ));
  // Navigator.of(context).pop();
}

gettask(BuildContext context) {
  final timeProvider = Provider.of<TimeProvider>(context, listen: false);
  final provider = context.read<SelectedBoxProvider>();
  String datevalue = provider.getFormattedDate().toString();

  print(datevalue);

  date.text = datevalue;
  reminder.text = '5 Minutes early';
  showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    context: context,
    builder: (context) {
      return TaskForm(timeProvider: timeProvider);
    },
  );
}

class TaskForm extends StatefulWidget {
  const TaskForm({
    super.key,
    required this.timeProvider,
  });

  final TimeProvider timeProvider;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formkey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: SizedBox(
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
                  key: _formkey2,
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
                          suffixIcon: const Icon(Icons.date_range),
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
                                keyboardType: TextInputType.none,
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
                                          final formattedTime = widget
                                              .timeProvider
                                              .formatTime(newTime, context);
                                          widget.timeProvider
                                              .updateStartTime(formattedTime);
                                          starttime.text =
                                              formattedTime; // Add this line
                                        },
                                      );
                                      timePicker.selectTime(context);
                                    },
                                    icon:
                                        const Icon(Icons.watch_later_outlined),
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
                                keyboardType: TextInputType.none,
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
                                          final formattedTime = widget
                                              .timeProvider
                                              .formatTime(newTime, context);
                                          widget.timeProvider
                                              .updateEndTime(formattedTime);
                                          endtime.text =
                                              formattedTime; // Add this line
                                        },
                                      );
                                      timePicker.selectTime(context);
                                    },
                                    icon:
                                        const Icon(Icons.watch_later_outlined),
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
                        value: options[0],
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color:
                                Provider.of<ThemeProvider>(context).isDarkMode
                                    ? Colors.black
                                    : Colors.white),
                        onChanged: (String? newValue) {
                          // Update the dropdown value when the user selects an option

                          reminder.text = newValue!;
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
                        message: "Add Task",
                        function: () async {
                          if (_formkey2.currentState != null &&
                              _formkey2.currentState!.validate()) {
                            await sendtask(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendtask(BuildContext context) async {
    print("running program");
    if (_formkey2.currentState != null && _formkey2.currentState!.validate()) {
      NoteModel n = NoteModel(
        title: title.text,
        note: note.text,
        date: date.text,
        starttime: starttime.text,
        endtime: endtime.text,
        reminder: reminder.text,
      );
      try {
        List<dynamic> result = await FirebaseStore.Savetask(n, date.text);
        if (result[0] == true) {
          // Extract the document ID from the result
          String docId = result[1];

          // Update the NoteModel with the retrieved document ID
          n = n.copyWith(id: docId);

          title.text = '';
          note.text = '';
          date.text = '';
          starttime.text = '';
          endtime.text = '';
          reminder.text = '';
          print("Done Data Saved");
          aftertrue(context);
        } else if (result[0] is String) {
          print(result[0]);
        } else {
          print("Something went wrong ");
        }
      } catch (e) {
        print("An error occurred: $e");
      }
    }
  }
}
