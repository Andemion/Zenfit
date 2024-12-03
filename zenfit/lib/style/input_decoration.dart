import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:zenfit/themes/color.dart'; 

InputDecoration greyInput(BuildContext context) {
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;
  
  return InputDecoration(
    labelStyle: TextStyle(color: themeColor.withOpacity(0.7)), 
    filled: true,
    fillColor: themeColor.withOpacity(0.1), 
    border: InputBorder.none,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: themeColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: themeColor),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
  );
}
