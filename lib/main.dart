import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'core/app_export.dart';
import 'widgets/notification.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase at the beginning
  await Firebase.initializeApp();

  // FireBaseApi service
  final _service = FireBaseApi();

  // Set the background message handler -- is imp!!
  FirebaseMessaging.onBackgroundMessage(
      _service.firebaseMessagingBackgroundHandler);

  // Run the app
  runApp(MyApp(service: _service));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ThemeHelper().changeTheme('primary');
}

class MyApp extends StatelessWidget {
  final FireBaseApi service;

  MyApp({required this.service});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          scaffoldMessengerKey: globalMessengerKey,
          theme: theme,
          title: 'ALive',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.startingscreen,
          routes: AppRoutes.routes,
          builder: (context, child) {
            // Ensure that the notifications are connected after the build is complete
            SchedulerBinding.instance.addPostFrameCallback((_) {
              service.connectNotification(context);
            });
            return child!;
          },
        );
      },
    );
  }
}
