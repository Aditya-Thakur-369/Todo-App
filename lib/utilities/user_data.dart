import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/model.dart';
import 'package:todo/screens/signin_screen.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final CollectionReference reference = store.collection("User");

enum AuthStatus { successful, failed }

class UserData {
  static userdata(String uid, String email, String name) async {
    Usermodel d = Usermodel(uid: uid, email: email, name: name);
    try {
      await store.collection("User").doc(uid).set(d.toMap());
    } catch (e) {
      print(e);
      log(e.toString());
    }
  }

  static sign_out() {
    FirebaseAuth.instance.signOut();
  }

  static Future resetPassword({required String email}) async {
    var d = await FirebaseFirestore.instance
        .collection("User")
        .where('email', isEqualTo: email)
        .get();

    try {
      if (d.docs.isNotEmpty) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        return true;
      } else {
        return 'user-not-found';
      }
    } on FirebaseAuthException catch (e) {
      print('-------------Error --------------:' + e.code);
      return e.code;
    } catch (e) {
      print('------------- Error ------------: $e');
    }
    return 'user-not-found';
  }
}
