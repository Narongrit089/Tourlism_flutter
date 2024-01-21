import 'package:flutter/material.dart';
// import 'package:csit2023/splash_screen.dart';
import 'package:tourlism_root_641463014/HomeScreen.dart';

import 'package:tourlism_root_641463014/Menu/Menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      // home: MenuPage(),
    );
  }
}
