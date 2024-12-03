import 'package:flutter/material.dart';

final ButtonStyle BleuButtonStyle = ElevatedButton.styleFrom(
  iconColor: Colors.white,
  foregroundColor: Colors.white,
  backgroundColor: const Color(0xFF1A43EE),
  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
);

final ButtonStyle WhiteButtonStyle = ElevatedButton.styleFrom(
  iconColor: const Color(0xFF1A43EE),
  foregroundColor: const Color(0xFF1A43EE),
  backgroundColor: Colors.white,
  side: const BorderSide(color: Color(0xFF1A43EE)),
  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
);