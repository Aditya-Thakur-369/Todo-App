import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/model.dart';
import 'package:todo/utilities/user_data.dart';

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
    print(info);
    Usermodel a = Usermodel(
      email: info['email'],
      name: info['name'],
    );
    print(a);

    return a;
  }

  static Future Savetask(NoteModel note, {required String title}) async {
    try {
      await reference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notes")
        .add(note.toMap());
      return true;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
    return true;
  }
}
