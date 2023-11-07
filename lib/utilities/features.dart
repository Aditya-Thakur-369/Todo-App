import 'package:flutter_share/flutter_share.dart';
import 'package:todo/models/model.dart';
import 'package:todo/utilities/firebase_database.dart';

class AdditionslFeature {
  Future<dynamic> saveTask({
    required String title,
    required String note,
    required String date,
    required String startTime,
    required String endTime,
    required String reminder,
  }) async {
    NoteModel n = NoteModel(
      title: title,
      note: note,
      date: date,
      starttime: startTime,
      endtime: endTime,
      reminder: reminder,
    );
    return null;
  }

}
