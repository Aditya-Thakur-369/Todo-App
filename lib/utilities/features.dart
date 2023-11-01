import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Feature {
  String getFormattedTime(TimeOfDay timeOfDay) {
    var now = DateTime.now();
    var formattedTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    var formatter = DateFormat('HH:mm');
    String formattedTimeString = formatter.format(formattedTime);
    print(formattedTimeString);
    return formattedTimeString;
  }
}

