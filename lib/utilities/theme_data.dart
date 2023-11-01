  import 'package:flutter/material.dart';

  class CustomTheme {
    static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
    
      // textTheme: TextTheme(bodyText1: ),
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.light,
      hintColor: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white70,
      ),
    );

    static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.dark,
      hintColor: Colors.purple,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
