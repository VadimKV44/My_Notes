import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  /// 1 - Light theme; 2 - Dark theme
  static int selectedTheme = 0;

  /// Saved theme
  static Future<bool> setTheme(int _selectedTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedTheme = _selectedTheme;
    return prefs.setInt('selectedTheme', selectedTheme);
  }

  /// Getting theme
  static Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedTheme = prefs.getInt('selectedTheme') ?? 1;
    return selectedTheme;
  }
}
