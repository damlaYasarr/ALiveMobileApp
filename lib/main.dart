import 'package:aLive/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'core/app_export.dart'; // Ensure this path is correct
import 'widgets/notification.dart'; // Ensure this path is correct
import 'package:flutter_localizations/flutter_localizations.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // FirebaseApi service
  final _service = FireBaseApi();

  // Set the background message handler
  FirebaseMessaging.onBackgroundMessage(
      _service.firebaseMessagingBackgroundHandler);

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Run the app
  runApp(MyApp(service: _service));
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
          theme: theme, // Ensure that 'theme' is defined in your code
          title: 'ALive',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.startingscreen,
          routes: AppRoutes.routes,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'), // English
            Locale('es'), // Spanish
            Locale('de'), // German
            Locale('tr'), // Turkish
            Locale('ar'), // Arabic
          ],
          builder: (context, child) {
            // Ensure notifications are connected after the build is complete
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
