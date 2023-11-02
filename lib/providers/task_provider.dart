import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/model.dart';
import 'package:todo/utilities/firebase_database.dart';

class TaskProvider with ChangeNotifier {
  List<NoteModel> _tasks = [];

  List<NoteModel> get tasks => _tasks;

  Future<void> fetchTasks(String date) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Task")
          .where('date', isEqualTo: date).where('isComplete', isEqualTo: false)
          .get();

      List<NoteModel> notes = [];
      print(notes);
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          final info = doc.data() as Map<String, dynamic>;
          NoteModel a = NoteModel.fromMap(info);
          notes.add(a);
        });
      }
        print(notes);

      if (notes.isEmpty) {
        print('No documents found for the specified date.');
      }

      _tasks = notes;
    } catch (e) {
      print('An error occurred: $e');
      _tasks = [];
    }

    notifyListeners();
  }
}
