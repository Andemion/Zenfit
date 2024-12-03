import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:zenfit/themes/color.dart'; 

ButtonStyle BleuButtonStyle(BuildContext context) {
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;
  return ElevatedButton.styleFrom(
    iconColor: Colors.white,
    foregroundColor: Colors.white,
    backgroundColor: themeColor,
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
  );
}

ButtonStyle WhiteButtonStyle(BuildContext context) {
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;
  return ElevatedButton.styleFrom(
    iconColor: themeColor,
    foregroundColor: themeColor, 
    backgroundColor: Colors.white,
    side: BorderSide(color: themeColor),
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
  );
}
