import 'package:flutter/material.dart';
import 'presentation/wine_selection_screen.dart';
import 'presentation/about_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WineSelectionScreen(),
      routes: {
        '/about': (context) => AboutScreen(), 
      },
    );
  }
}
