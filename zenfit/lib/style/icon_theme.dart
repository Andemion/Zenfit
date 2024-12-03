import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:zenfit/themes/color.dart'; 

IconThemeData whiteIcon(BuildContext context) {
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;
  return IconThemeData(
    color: Colors.white, 
  );
}

Icon timerIconStyle(BuildContext context) {
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;
  return Icon(
    Icons.timer,
    color: themeColor, 
  );
}
