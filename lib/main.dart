import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'core/app_export.dart';
import 'widgets/notification.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final _service = FireBaseApi();
  try {
    _service.ConnectNotrifc(); //this code line provides to call all.
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: theme,
          title: 'ALive',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.startingscreen,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
