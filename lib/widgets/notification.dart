import 'dart:developer'; //here is for to get token

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:grock/grock.dart';

class FireBaseApi {
  late final FirebaseMessaging msg;
  void SettingNotrification() async {
    await msg.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void ConnectNotrifc() async {
    await Firebase.initializeApp();
    msg = FirebaseMessaging.instance; //making initialize
    msg.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    SettingNotrification();
    FirebaseMessaging.onBackgroundMessage(onBackgroundMsg);
    // listen msg coming from firebase- event turning msh
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      //print("ne çıktı falımda kız : ${event.notification?.title}"); here is control for notrification from firebasewebsite with token
      Grock.snackBar(
          title: " ${event.notification?.title}",
          description: "${event.notification?.body}",
          opacity: 0.5,
          position: SnackbarPosition.top);
    });
    msg.getToken().then((value) => print("token : $value"));
  }

  static Future<void> onBackgroundMsg(RemoteMessage event) async {
    await Firebase.initializeApp();
    print("on background msh: ${event.messageId}");
  }
}
