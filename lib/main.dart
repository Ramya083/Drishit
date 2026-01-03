// lib/main.dart
//
// Entry point for Drishti app. Initializes available cameras and launches HomeScreen.
//
// Comments throughout the code explain structure and where to expand functionality.

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch available cameras for the device. The camera plugin requires this.
  final cameras = await availableCameras();

  runApp(DrishtiApp(cameras: cameras));
}

class DrishtiApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const DrishtiApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drishti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // High contrast theme - dark background with bright accent
        brightness: Brightness.dark,
        primaryColor: Colors.yellow[700],
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(64),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: HomeScreen(cameras: cameras),
    );
  }
}
