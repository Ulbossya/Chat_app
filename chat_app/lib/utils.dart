//utils
import 'package:flutter/material.dart';
import 'dart:math';

Color getRandomColor() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1,
  );  
}

Color getAvatarBackgroundColor(String contactName) {
  return getRandomColor();
}

String getInitials(String name) {
  List<String> names = name.split(" ");
  String initials = "";
  for (var i = 0; i < names.length; i++) {
    initials += names[i][0].toUpperCase();
  }
  return initials;
}
