import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/main.dart';
import 'package:todo/utilities/theme_data.dart';

class ThemeProvider extends ChangeNotifier {
  static const String THEMEKEY = "theme";
  bool isDarkMode = false;

  ThemeProvider() {
    themechange();
  }

  void themechange() async {
    var sharedPref = await SharedPreferences.getInstance();
    var theme = sharedPref.getBool(THEMEKEY);
    if (theme != null) {
      isDarkMode = theme;
      notifyListeners();
    }
  }

  void toggleTheme() async {
    isDarkMode = !isDarkMode;
    notifyListeners();
    await _saveTheme();
  }

  _saveTheme() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(THEMEKEY, isDarkMode);
  }

  // ThemeData getTheme() {
  //   return isDarkMode
  //       ? ThemeData.dark(
  //           useMaterial3: true,

  //         )
  //       : ThemeData.light(
  //           useMaterial3: true,
  //         );
  // }
  ThemeData getTheme() {
    return isDarkMode ? CustomTheme.lightTheme : CustomTheme.darkTheme;
  }

  IconData getThemeIcon() {
    return isDarkMode ? Icons.dark_mode_outlined : Icons.wb_sunny_outlined;
  }
}
