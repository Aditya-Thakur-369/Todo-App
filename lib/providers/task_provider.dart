import 'package:flutter/material.dart';
import 'package:todo/models/model.dart';
import 'package:todo/utilities/firebase_database.dart';

class TaskProvider with ChangeNotifier {
  List<NoteModel> tasks = [];
  List<NoteModel> completedtask = [];

  Future<List<NoteModel>> fetchTasks(String date) async {
    try {
      final notes = await FirebaseStore.GetTask(date);
     
      tasks = notes;
      notifyListeners();
    } catch (e) {
      print('An error occurred: $e');
    }
    return tasks;
  }


  Future<List<NoteModel>> fetchdoneTasks(String date) async {
    try {
      final notesdoc = await FirebaseStore.GetDoneTask(date);
     
      completedtask = notesdoc;
      notifyListeners();
    } catch (e) {
      print('An error occurred: $e');
    }
    return completedtask;
  }
  notifyListeners();
}
