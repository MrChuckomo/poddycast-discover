import 'package:flutter/material.dart';

final regularTextStyle = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const elevatedButtonStyle = ButtonStyle(
  elevation: WidgetStatePropertyAll(6),
  backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
  iconColor: WidgetStatePropertyAll(Colors.white),
  foregroundColor: WidgetStatePropertyAll(Colors.white),
);

// MARK: FunFair Colors

const funRead = Color.fromARGB(255, 239, 69, 91);
const funGold = Color.fromARGB(255, 253, 194, 66);
const funTeal = Color.fromARGB(255, 53, 155, 140);
const funSand = Color.fromARGB(225, 223, 228, 205);
const funSandDark = Color.fromARGB(225, 166, 141, 111);
const funSandDarker = Color.fromARGB(224, 86, 70, 51);
