import 'package:flutter/material.dart';

final InputDecoration greyInput = InputDecoration(
  labelStyle: const TextStyle(color: Color(0xFF777777)),
  filled: true,
  fillColor: const Color(0xFFEBE9E9),
  border: InputBorder.none,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(color: Colors.transparent),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(color: Colors.transparent),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0)
);