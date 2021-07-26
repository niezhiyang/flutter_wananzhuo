import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeConstans {
  static const Map<String, Color> themeColorMap = {
    'gray': Colors.grey,
    'blue': Colors.blue,
    'blueAccent': Colors.blueAccent,
    'cyan': Colors.cyan,
    'deepPurple': Colors.purple,
    'deepPurpleAccent': Colors.deepPurpleAccent,
    'deepOrange': Colors.orange,
    'green': Colors.green,
    'indigo': Colors.indigo,
    'indigoAccent': Colors.indigoAccent,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'red': Colors.red,
    'teal': Colors.teal,
    'black': Colors.black,
  };

  static List<ThemeData> themeList = [
    ThemeData(
      primaryColor: Colors.pink,
      primaryColorDark: Colors.pinkAccent,
      accentColor: Colors.pinkAccent,
      bottomAppBarColor: Colors.pinkAccent,
    ),
    ThemeData(
        primaryColor: const Color(0xFF2196f3),
        primaryColorDark: const Color(0xFF1565C0),
        accentColor: const Color(0xFF1565C0),
        bottomAppBarColor: const Color(0xFF1565C0),
        buttonColor: const Color(0xFF1565C0)),
    ThemeData(
        primaryColor: const Color(0xFF673AB7),
        primaryColorDark: const Color(0x99673AB7),
        accentColor: const Color(0x99673AB7),
        bottomAppBarColor: const Color(0x99673AB7),
        buttonColor: const Color(0x99673AB7)),
    ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        primaryColorDark: const Color(0xFF2E7D32),
        accentColor: const Color(0xFF2E7D32),
        bottomAppBarColor: const Color(0xFF2E7D32),
        buttonColor: const Color(0xFF2E7D32)),
    ThemeData(
        primaryColor: const Color(0xFFFDD835),
        primaryColorDark: const Color(0x99FDD835),
        accentColor: const Color(0x99FDD835),
        bottomAppBarColor: const Color(0x99FDD835),
        buttonColor: const Color(0x99FDD835)),
    ThemeData(
        primaryColor: const Color(0xFFF44336),
        primaryColorDark: const Color(0x99F44336),
        accentColor: const Color(0x99F44336),
        bottomAppBarColor: const Color(0x99F44336),
        buttonColor: const Color(0x99F44336)),
  ];
}

class ThemeState with ChangeNotifier, DiagnosticableTreeMixin {
  int colorIndex = 0;


  void changeThemeData(int color) {
    colorIndex = color;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('color', colorIndex));
  }
}
