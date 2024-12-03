import 'package:flutter/material.dart';

class ThemeColorProvider with ChangeNotifier {
  Color _themeColor = const Color(0xFF1A43EE); 

  Color get themeColor => _themeColor;

  void updateThemeColor(String colorName) {
    switch (colorName) {
      case 'Bleu':
        _themeColor = const Color(0xFF1A43EE);
        break;
      case 'Rouge':
        _themeColor = Colors.red;
        break;
      case 'Vert':
        _themeColor = Colors.green;
        break;
      default:
        _themeColor = Colors.blue;
    }
    notifyListeners(); 
  }
}
