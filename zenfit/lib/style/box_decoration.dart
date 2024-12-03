import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:zenfit/themes/color.dart';

BoxDecoration whiteBox(BuildContext context) {
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;
  return BoxDecoration(
    border: Border.all(color: themeColor),
    borderRadius: BorderRadius.circular(8),
  );
}

BoxDecoration greyBox(BuildContext context) {
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;
  return BoxDecoration(
    color: Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF333333)
        : const Color(0xFFEBE9E9),
    borderRadius: BorderRadius.circular(50),
  );
}
