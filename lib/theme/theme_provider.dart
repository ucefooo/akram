import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fixahead/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;
  late SharedPreferences _prefs;

  ThemeProvider() {
    _themeData = lightMode; // Default to light mode
    _loadThemePreference();
    
  }

  ThemeData get themeData => _themeData;

  Future<void> _loadThemePreference() async {
    _prefs = await SharedPreferences.getInstance();
    final bool isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    setThemeData(isDarkMode ? darkMode : lightMode);
  }

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isOn) async {
    _themeData = isOn ? darkMode : lightMode;
    await _prefs.setBool('isDarkMode', isOn);
    notifyListeners();
  }
}