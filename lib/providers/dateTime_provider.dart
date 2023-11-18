import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatesProvider extends ChangeNotifier {
   List<dynamic> calender() {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    List<List<int>> date = [
      [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], // Non-leap year
      [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] // Leap year
    ];

  List<List<Map<String, dynamic>>> dates = [];

  for (int year = currentYear; year <= 2024; year++) {
    List<Map<String, dynamic>> yearData = [];
    int startMonth = (year == currentYear) ? currentMonth - 1 : 0;

    for (int i = startMonth; i < months.length; i++) {
      int dateInMonth = (i == 1 && isLeapYear(year)) ? date[1][i] : date[0][i];
      List<Map<String, dynamic>> monthData = [];
      int startDay = (year == currentYear && i == currentMonth - 1) ? currentDay : 1;

      for (int j = startDay; j <= dateInMonth; j++) {
        monthData.add({
          'month': months[i % 12],
          'date': j,
          'year': year,
        });
      }
      yearData.addAll(monthData);
    }
    dates.add(yearData);
  }

  return dates;
}


  bool isLeapYear(int year) {
    if (year % 4 != 0) {
      return false;
    } else if (year % 100 != 0) {
      return true;
    } else if (year % 400 != 0) {
      return false;
    } else {
      return true;
    }
  }

  void updateDates(List<dynamic> dates) {
    DateTime now = DateTime.now();
    for (var year in dates) {
      for (var month in year) {
        if (now.year == month['year']) {
          if (now.month == getMonthNumber(month['month'])) {
            if (now.day > month['date']) {
              month['date'] = now.day; // Set the current day if it has passed
            }
          }
        }
      }
    }
    notifyListeners();
  }

  int getMonthNumber(String monthName) {
    switch (monthName) {
      case 'Jan':
        return 1;
      case 'Feb':
        return 2;
      case 'Mar':
        return 3;
      case 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'June':
        return 6;
      case 'July':
        return 7;
      case 'Aug':
        return 8;
      case 'Sep':
        return 9;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
      default:
        return 1;
    }
  }

  List<Map<String, dynamic>> showDates() {
    List<dynamic> result = calender();
    updateDates(result);
    List<Map<String, dynamic>> resultList = [];
    for (int i = 0; i < result.length; i++) {
      for (int j = 0; j < result[i].length; j++) {
        if (result[i][j]['date'] != null) {
          DateTime dateTime = DateTime(
              result[i][j]['year'], getMonthNumber(result[i][j]['month']), result[i][j]['date']);
          String dayOfWeek = DateFormat('EEEE').format(dateTime);
          Map<String, dynamic> data = {
            'year': result[i][j]['year'],
            'month': result[i][j]['month'],
            'date': result[i][j]['date'],
            'dayOfWeek': dayOfWeek,
          };
          resultList.add(data);
        }
      }
    }
  
    return resultList;
  }
}
