// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Usermodel {
  String? uid;
  String? name;
  String? email;
  Usermodel({
    this.uid,
    this.name,
    this.email,
  });

  Usermodel copyWith({
    String? uid,
    String? name,
    String? email,
  }) {
    return Usermodel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usermodel.fromJson(String source) =>
      Usermodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Usermodel(uid: $uid, name: $name, email: $email)';

  @override
  bool operator ==(covariant Usermodel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.name == name && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ email.hashCode;
}

class NoteModel {
  String? id;
  String? title;
  String? note;
  String? date;
  String? starttime;
  String? endtime;
  String? reminder;
  String? completedTime;
  bool? isCompleted;

  NoteModel({
    this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.starttime,
    required this.endtime,
    required this.reminder,
    this.completedTime,
    this.isCompleted = false,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? note,
    String? date,
    String? starttime,
    String? endtime,
    String? reminder,
    String? completedTime,
    bool? isCompleted,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
      starttime: starttime ?? this.starttime,
      endtime: endtime ?? this.endtime,
      reminder: reminder ?? this.reminder,
      completedTime: completedTime ?? this.completedTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'starttime': starttime,
      'endtime': endtime,
      'reminder': reminder,
      'completedTime': completedTime,
      'isCompleted': isCompleted,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      starttime: map['starttime'] != null ? map['starttime'] as String : null,
      endtime: map['endtime'] != null ? map['endtime'] as String : null,
      reminder: map['reminder'] != null ? map['reminder'] as String : null,
      completedTime: map['completedTime'] != null ? map['completedTime'] as String : null,
      isCompleted: map['isCompleted'] != null ? map['isCompleted'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) => NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, note: $note, date: $date, starttime: $starttime, endtime: $endtime, reminder: $reminder, completedTime: $completedTime, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(covariant NoteModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.note == note &&
      other.date == date &&
      other.starttime == starttime &&
      other.endtime == endtime &&
      other.reminder == reminder &&
      other.completedTime == completedTime &&
      other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      note.hashCode ^
      date.hashCode ^
      starttime.hashCode ^
      endtime.hashCode ^
      reminder.hashCode ^
      completedTime.hashCode ^
      isCompleted.hashCode;
  }
}
