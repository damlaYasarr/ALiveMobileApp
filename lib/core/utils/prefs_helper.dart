import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static const String _notificationSoundKey = 'notification_sound';

  static Future<void> setNotificationSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_notificationSoundKey, value);
  }

  static Future<bool> getNotificationSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationSoundKey) ?? true; // Default is true
  }
}
