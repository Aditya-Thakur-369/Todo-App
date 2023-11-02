import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/model.dart';
import 'package:todo/screens/bottomsheet_addtask.dart';

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

  static Future Savetask(NoteModel note, String date) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Task")
          // .doc(date)
          .add(note.toMap());
      return true;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
    return null;
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
      }
      return notes;
    } catch (e) {
      print('An error occurred: $e');
      return []; // return an empty list or any other suitable action
    }
  }
}
