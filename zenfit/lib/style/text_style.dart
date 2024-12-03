import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenfit/themes/color.dart'; 

TextStyle TitleStyle = const TextStyle(
  color: Color(0xFF000000),
  fontSize: 40,
  fontWeight: FontWeight.bold,
);

TextStyle ContentTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).brightness == Brightness.dark 
      ? Colors.white
      : Colors.black, 
    fontSize: 18,
  );
}

TextStyle BleuTitleXSTextStyle(BuildContext context) {
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;

  return TextStyle(
    color: themeColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

TextStyle whiteTextStyle = const TextStyle(
  color: Colors.white,
);
