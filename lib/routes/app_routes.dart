import '../presentation/starting_screen/starting_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/general_screen/general_screen.dart';
import '../presentation/calendar_screen/calendar_screen.dart';
import '../presentation/add_habit_screen/addhabit_screen.dart';
import '../presentation/overview_screen/overview_screen.dart';
import '../presentation/feedback_screen/feedback_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import 'package:http/http.dart' as http;

late final http.Client httpClient;

class AppRoutes {
  static const String startingscreen = '/startingscreen';
  static const String generalScreen = '/general_screen';

  static const String calendarScreen = '/calendar_screen';

  static const String addhabitscreen = '/addhabit_screen';

  static const String overviewScreen = '/overview_screen';

  static const String feedbackscreen = '/feedback_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    startingscreen: (context) => StartingScreen(),
    generalScreen: (context) => GeneralScreen(),
    calendarScreen: (context) => CalendarScreen(),
    addhabitscreen: (context) => AddHbabitScreen(),
    overviewScreen: (context) => OverviewScreen(),
    feedbackscreen: (context) => FeedbackScreen(),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}
