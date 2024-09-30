import 'package:flutter/material.dart';
import 'home.dart'; // Import your home screen

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Your home screen
    );
  }
}
