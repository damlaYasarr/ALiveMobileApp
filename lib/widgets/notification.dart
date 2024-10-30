import 'dart:async';
import 'dart:convert';
import 'package:aLive/core/utils/image_constant.dart';
import 'package:aLive/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:aLive/core/utils/prefs_helper.dart';
import 'package:aLive/core/utils/playNotificationSound.dart';

class FireBaseApi {
  late final FirebaseMessaging msg;
  late final String email = Globalemail.useremail;
  Timer? _notificationTimer; // Store the Timer instance

  FireBaseApi();

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      msg = FirebaseMessaging.instance;
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }

  // Request notification permissions
  void requestNotificationPermissions() async {
    try {
      await msg.requestPermission(
        alert: true,
        sound: true,
        badge: true,
      );
    } catch (e) {
      print('Error requesting notification permission: $e');
    }
  }

  void connectNotification(BuildContext context) async {
    await initializeFirebase();
    requestNotificationPermissions();

    msg.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      bool soundEnabled = await PrefsHelper.getNotificationSound();

      if (soundEnabled) {
        playNotificationSound();
      }

      _showNotification(context, event);
    });

    try {
      // Get FCM token
      String? token = await msg.getToken();

      print("Received token: $token");
      if (token != null) {
        print("Token: $token");
        scheduleNotification(token, Globalemail.useremail);
      } else {
        print("FCM token not received");
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }

    startPeriodicNotificationSending();
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  void _showNotification(BuildContext context, RemoteMessage event) {
    _notificationTimer?.cancel(); // Cancel any existing timer
    playNotificationSound();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Red icon tapped, dismiss notification
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _notificationTimer?.cancel(); // Cancel timer
              },
              child: Icon(Icons.error, color: Colors.red),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Green icon tapped, approve habit and update database
                String? name = event.notification?.body ?? "No body";
                DateTime date = DateTime.now();
                String datex = DateFormat('dd.MM.yyyy').format(date);
                print('$name, $datex');

                // Approve the habit and save it to the database
                ApproveTheHabit(name, email, datex);

                // Dismiss the Snackbar
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _notificationTimer?.cancel(); // Cancel timer
              },
              child: Icon(Icons.check_circle, color: Colors.green),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                event.notification?.title ?? "No title",
                style: TextStyle(color: Colors.black, fontSize: 15),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                "${S.of(context).Letsdoit}: ${event.notification?.body ?? "No body"}",
                style: TextStyle(color: Colors.black, fontSize: 15),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        duration: Duration(minutes: 1),
      ),
    );

    // Automatically dismiss notification after 30 seconds
    _notificationTimer = Timer(Duration(seconds: 30), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  Future<void> ApproveTheHabit(String name, String email, String date) async {
    final Uri url = Uri.parse('http://192.168.1.102:3000/approvaltime');

    final Map<String, String> requestBody = {
      "email": email,
      "name": name,
      "complete_days": date,
    };

    String body = json.encode(requestBody);

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Habit approval request successful');

        print('Failed to approve habit: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during habit approval request: $e');
    }
  }

  // Schedule notification via HTTP request
  Future<void> scheduleNotification(String token, String email) async {
    final url = Uri.parse(
        'http://192.168.1.102:3000/send-notification?token=$token&email=$email');
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('Notification scheduled successfully');
      } else {
        print('Failed to schedule notification');
      }
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // Start periodic notification sending
  void startPeriodicNotificationSending() {
    const duration = Duration(minutes: 1);
    _notificationTimer = Timer.periodic(duration, (Timer timer) async {
      try {
        String? token = await msg.getToken();
        if (token != null) {
          await scheduleNotification(token, Globalemail.useremail);
          print('Periodic notification sent');
        } else {
          print('FCM token not available');
          timer.cancel(); // Stop the timer if token is not available
        }
      } catch (e) {
        print('Error sending periodic notification: $e');
        timer.cancel(); // Stop the timer on error
      }
    });
  }
}
