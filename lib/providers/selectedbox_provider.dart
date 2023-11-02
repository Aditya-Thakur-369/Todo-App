import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// ... other imports

class SelectedBoxProvider with ChangeNotifier {
  Map<String, dynamic> _selectedBox = {};

  Map<String, dynamic> get selectedBox => _selectedBox;

  String getFormattedDate() {
    if (_selectedBox.isNotEmpty) {
      DateTime date = DateTime(_selectedBox['year'],
          getMonthNumber(_selectedBox['month']), _selectedBox['date']);
      return DateFormat('d MMM y').format(date);
    } else {
      return '';
    }
  }

  void updateSelectedBox(Map<String, dynamic> newSelectedBox) {
    _selectedBox = newSelectedBox;
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
}
