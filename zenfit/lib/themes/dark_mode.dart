import 'package:flutter/material.dart';

class DarkModeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Par défaut, le mode sombre est désactivé

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode; // Inverse le mode sombre
    notifyListeners(); // Notifie les widgets qui écoutent ce provider
  }
}
