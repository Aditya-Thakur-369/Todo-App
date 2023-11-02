import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeProvider extends ChangeNotifier {
  late String _startTime;
  late String _endTime;

  String get startTime => _startTime;
  String get endTime => _endTime;

  void updateStartTime(String newStartTime) {
    _startTime = newStartTime;
    notifyListeners();
  }

  void updateEndTime(String newEndTime) {
    _endTime = newEndTime;
    notifyListeners();
  }

  String formatTime(TimeOfDay time, BuildContext context) {
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(
        DateTime(now.year, now.month, now.day, time.hour, time.minute));
    return formattedTime;
  }

  // Additional methods and functionality can be added here
}
