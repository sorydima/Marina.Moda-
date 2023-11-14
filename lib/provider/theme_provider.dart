import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/Colors.dart';
import '../main.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      return themeMode == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  ThemeProvider(bool darkThemeOn) {
    themeMode = darkThemeOn ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isOn) async {
    if (isOn) {
      themeMode = ThemeMode.dark;
      pref.setBool('isDarkTheme', true);
    } else {
      themeMode = ThemeMode.light;
      pref.setBool('isDarkTheme', false);
    }

    notifyListeners();
  }

  ThemeMode getTheme() => themeMode;
}

class AppThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: backgroundColorDarkTheme,
      colorScheme: const ColorScheme.dark(),
      fontFamily: 'SegUI',
      primaryColor: whiteColor,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
            color: whiteColor, fontWeight: FontWeight.bold, fontSize: 18),
        bodyMedium: TextStyle(
          color: whiteColor,
          fontSize: 16,
        ),
      ),
      iconTheme: const IconThemeData(color: whiteColor),
      cardColor: primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
            color: whiteColor, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          linearTrackColor: indicatorColor2,
          color: indicatorColor1,
          refreshBackgroundColor: indicatorColor3),
      highlightColor: primaryColor.withOpacity(0.2),
      indicatorColor: accentColor,
      shadowColor: Colors.transparent);

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundColorLightTheme,
    colorScheme: const ColorScheme.light(),
    fontFamily: 'SegUI',
    primarySwatch: primaryColors,
    primaryColor: primaryColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
      bodyMedium: TextStyle(color: primaryColor, fontSize: 16),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
    ),
    iconTheme: const IconThemeData(color: primaryColor),
    cardColor: whiteColor,
    appBarTheme: const AppBarTheme(
        backgroundColor: whiteColor,
        titleTextStyle: TextStyle(
            color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
        iconTheme: IconThemeData(color: primaryColor)),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        linearTrackColor: indicatorColor2,
        color: indicatorColor1,
        refreshBackgroundColor: indicatorColor3),
    highlightColor: primaryColor.withOpacity(0.2),
    indicatorColor: accentColor,
    shadowColor: Colors.grey[400],
  );
}
