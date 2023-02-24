import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:on_the_go_reminder/views/welcome_screen.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAUR4OfYoNGhH-b56pfLiuceo94z3CnZhc",
      appId: "1:59085036286:android:8c9829bfe8db778413e3af",
      messagingSenderId: "59085036286",
      projectId: "on-the-go-reminder",
    ),
  );
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On the Go Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
