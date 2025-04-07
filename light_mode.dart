import 'package:flutter/material.dart';

ThemeData LightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(surface: Colors.grey.shade800
    ,primary: Colors.pink.shade700,
    secondary: Colors.pink.shade600,
    inversePrimary: Colors.pink.shade200),
    textTheme: ThemeData.light().textTheme.apply(bodyColor: Colors.grey[300],
    displayColor: Colors.white)
    
    );
