import 'package:audioplayers/audioplayers.dart';

AudioPlayer audioPlayer = AudioPlayer();

void playNotificationSound() async {
  await audioPlayer
      .play(AssetSource('sounds/notification.mp3')); // Path to your sound file
}
