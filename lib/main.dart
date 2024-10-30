import 'package:firebase_core/firebase_core.dart';
import 'package:fitness/view/home/activity_tracker_view.dart';
import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:fitness/view/on_boarding/started_view.dart';
import 'package:fitness/view/home/notification_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common/colo_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the app is running on the web and initialize Firebase accordingly
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDk_4R2jimzXnPmli6qkg3nhlRnxBgW1Cs",
        appId: "1:998991727193:web:3893d4134c978d63a47f48",
        messagingSenderId: "998991727193",
        projectId: "fitnesss-fa244",
      ),
    );
  } else {
    await Firebase.initializeApp(); // For mobile platforms
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: // CompleteProfileView(),
          const StartedView(),
      //const ActivityTrackerView()
      //const NotificationView(),
    );
  }
}
