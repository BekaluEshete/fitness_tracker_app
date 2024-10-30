import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseNotifireApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotificationPush() async {
    // Request notification permissions for iOS
    await _firebaseMessaging.requestPermission();

    // Get the FCM token (useful for testing or targeted notifications)
    final fCMToken = await _firebaseMessaging.getToken();
    print("FCM Token: $fCMToken");

    // Handle messages received while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Foreground message received: ${message.notification!.title}");
        // Show a dialog or update the UI as necessary
      }
    });

    // Handle messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from notification: ${message.notification!.title}");
      // Navigate to specific screen or handle the message data if needed
    });

    // Set a background message handler to manage notifications when the app is closed
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

// Background message handler (for messages received when the app is completely closed)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.notification!.title}");
}
