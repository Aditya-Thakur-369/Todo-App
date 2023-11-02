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
    

    print("Done ");
    print(title);
    print(note);
    print(date);
    print(startTime);
    print(endTime);
    print(reminder);

    // Uncomment this section when FirebaseStore.Savetask is available
    // try {
    //   dynamic rs = await FirebaseStore.Savetask(n);
    //   if (rs is String) {
    //     print("Error occurred: $rs");
    //   } else if (rs is bool) {
    //     print(rs);
    //   }
    // } catch (e) {
    //   print("An error occurred: $e");
    // }

    // Add a return statement at the end
    return null; // Replace 'null' with an appropriate value if needed
  }
}
