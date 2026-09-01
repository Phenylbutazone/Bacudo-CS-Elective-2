import 'package:flutter/material.dart';

/// Stateful theme toggle backed by a [ChangeNotifier].
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;

  ThemeMode get mode => _mode;

  bool get isVisible => _mode == ThemeMode.light;

  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

final themeNotifier = ThemeNotifier();
