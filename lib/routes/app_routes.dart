import '../presentation/starting_screen/starting_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/general_screen/general_screen.dart';
import '../presentation/calendar_screen/calendar_screen.dart';
import '../presentation/mainpage_screen/mainpage_screen.dart';
import '../presentation/overview_screen/overview_screen.dart';
import '../presentation/payment_screen/payment_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String startingscreen = '/startingscreen';
  static const String generalScreen = '/general_screen';

  static const String calendarScreen = '/calendar_screen';

  static const String mainpageScreen = '/mainpage_screen';

  static const String overviewScreen = '/overview_screen';

  static const String paymentScreen = '/payment_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    startingscreen: (context) => StartingScreen(),
    generalScreen: (context) => GeneralScreen(),
    calendarScreen: (context) => CalendarScreen(),
    mainpageScreen: (context) => MainpageScreen(),
    overviewScreen: (context) => OverviewScreen(),
    paymentScreen: (context) => PaymentScreen(),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}
