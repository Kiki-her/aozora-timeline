import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// テーマProvider (ダークモード管理)
class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  /// 保存されたテーマ設定を読み込み
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  /// ダークモードトグル
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  /// テーマモード取得
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
