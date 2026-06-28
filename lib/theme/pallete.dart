import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider((ref) {
  return ThemeNotifier();
});

class Pallete {
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(color: whiteColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: drawerColor),
    primaryColor: redColor,
    // colorScheme: ThemeData.dark().colorScheme.copyWith(surface: drawerColor),
    // backgroundColor: drawerColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: blackColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: whiteColor),
    primaryColor: redColor,
    // colorScheme: ThemeData.dark().colorScheme.copyWith(surface: whiteColor),
    // backgroundColor: whiteColor,
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({this._mode = ThemeMode.dark})
    : super(Pallete.darkModeAppTheme);

  ThemeMode get mode => _mode;

  void getTheme() async {
    final prefs = SharedPreferencesAsync();
    final theme = await prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    final prefs = SharedPreferencesAsync();
    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
      await prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
      await prefs.setString('theme', 'dark');
    }
  }
}
