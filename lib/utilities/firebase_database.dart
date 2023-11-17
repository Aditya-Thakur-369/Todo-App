import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/model.dart';
import 'package:todo/screens/bottomsheet_addtask.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/utilities/notification_service.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final CollectionReference reference = store.collection("Users");

class FirebaseStore {
  static Future createuser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      //   .then((value) async {
      // await UserData.userdata(value.user!.uid);
      return true;
      // }
      // );
    } on FirebaseAuthException catch (e) {
      return e.code; // Return the exception code
    } catch (e) {
      return e; // Return any other type of exception
    }
    return true;
  }

  static Future signinuser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
    return true;
  }

  static Future<Usermodel> userinfo() async {
    var doc = await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final info = doc.data() as Map<String, dynamic>;
    // print(info);
    Usermodel a = Usermodel(
      email: info['email'],
      name: info['name'],
    );
    // print(a);

    return a;
  }

  static Future<List<dynamic>> Savetask(NoteModel note, String date) async {
    try {
      CollectionReference taskCollection = FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Task");

      DocumentReference docRef = await taskCollection.add(note.toMap());

      String docId = docRef.id;
      print("Document ID: $docId");

      // Update the document with the document ID
      await docRef.update({'id': docId});

      return [true, docId];
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception: ${e.code}");
      return [e.code];
    } catch (e) {
      print("An error occurred: $e");
      return [e.toString()];
    }
  }

  static Future<List<NoteModel>> GetDoneTask(String date) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Task")
          .where('date', isEqualTo: date)
          .where('isCompleted', isEqualTo: true)
          .get();

      List<NoteModel> notes = [];

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          final info = doc.data() as Map<String, dynamic>;
          NoteModel a = NoteModel.fromMap(info);
          notes.add(a);
        });
      }

      if (notes.isEmpty) {
        print('No documents found for the specified date.');
        return [];
      }
      return notes;
    } catch (e) {
      print('An error occurred: $e');
      return []; // return an empty list or any other suitable action
    }
  }

  static Future<List<NoteModel>> GetHistory() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Task")
          .get();

      List<NoteModel> notes = [];
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          final info = doc.data() as Map<String, dynamic>;
          NoteModel a = NoteModel.fromMap(info);
          notes.add(a);
        });
      }

      if (notes.isEmpty) {
        print('No documents found for the specified date in get history .');
        return [];
      }
      return notes;
    } catch (e) {
      print('An error occurred: $e');
      return []; // return an empty list or any other suitable action
    }
  }

  static Future<List<NoteModel>> GetTask(String date) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Task")
          .where('date', isEqualTo: date)
          .where('isCompleted', isEqualTo: false)
          .get();

      List<NoteModel> notes = [];
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          final info = doc.data() as Map<String, dynamic>;
          NoteModel a = NoteModel.fromMap(info);
          notes.add(a);
        });
      }

      if (notes.isEmpty) {
        print('No documents found for the specified date.');
        return [];
      }
      return notes;
    } catch (e) {
      print('An error occurred: $e');
      return []; // return an empty list or any other suitable action
    }
  }

  static Future<bool> Updatask(
      NoteModel task, String docId, String userId) async {
    try {
      print(docId);
      DocumentReference ref = FirebaseFirestore.instance
          .collection("User")
          .doc(userId)
          .collection("Task")
          .doc(docId);

      DocumentSnapshot snapshot = await ref.get();
      if (!snapshot.exists) {
        throw Exception("Document does not exist");
      }

      await ref.update(task.toMap());
      return true;
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  static Future<bool> DeleteTask(String docId, String userId) async {
    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection("User")
          .doc(userId)
          .collection("Task")
          .doc(docId);
      await ref.delete();
      return true;
    } catch (e) {
      print('An error occurred: $e');
    }
    return false;
  }

  static Future<bool> MarkasRead(
      String docId, String userId, String time) async {
    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection("User")
          .doc(userId)
          .collection("Task")
          .doc(docId);
      await ref.update({'isCompleted': true, 'completedTime': time});
      return true;
    } catch (e) {
      print('An error occurred: $e');
    }
    return false;
  }

  static Future<dynamic> SendMailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      print("Mail Send");
      return true;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
  }
  
  
  
//   static Future<dynamic> thrownotificaion(String date) async {
//   try {
//     var querySnapshot = await FirebaseFirestore.instance
//         .collection("User")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection("Task")
//         .where('date', isEqualTo: date)
//         .where('isCompleted', isEqualTo: false)
//         .get();

//     List<NoteModel> notes = [];
//     if (querySnapshot.docs.isNotEmpty) {
//       querySnapshot.docs.forEach((doc) {
//         // Access the 'date' field directly, assuming it's a Timestamp
//         final info = doc.data() as Map<String, dynamic>;
//         NoteModel a = NoteModel.fromMap(info);
//         notes.add(a);
//         NotificationService().scheduleNotifications(a);
//       });
//     }

//     if (notes.isEmpty) {
//       print('No documents found for the specified date in get notifications.');
//       return [];
//     }
//     print(notes);
//     return notes;
//   } catch (e) {
//     print('An error occurred: $e');
//     return []; // return an empty list or any other suitable action
//   }
// }

  // static Future<bool> MarkasRead() async {}
}
