import 'package:aLive/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:audioplayers/audioplayers.dart'; // Import for audio playback

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationSound = true; // Initial value
  final TextEditingController _commentController =
      TextEditingController(); // Controller for comments
  int _rating = 0; // For star rating
  GoogleSignInAccount?
      _currentUser; // To store the current user's Google account

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = await _googleSignIn.signInSilently();
    setState(() {}); // Refresh the UI
  }

  Future<void> _signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      setState(() {}); // Refresh the UI
    } catch (error) {
      print(error);
    }
  }

  void _playNotificationSound() async {
    if (_notificationSound) {
      await _audioPlayer.play(AssetSource(
          'sounds/notification.mp3')); // Change to your sound file path
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(S.of(context).Settings, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            if (_currentUser != null) ...[
              CircleAvatar(
                backgroundImage: NetworkImage(_currentUser!.photoUrl ?? ''),
                radius: 40,
              ),
              SizedBox(height: 8),
              Text(
                _currentUser!.displayName ?? 'No Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                _currentUser!.email,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
            ] else ...[
              Text('You are not signed in.'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signIn,
                child: Text('Sign in with Google'),
              ),
            ],

            // Notification Sound Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).Notification,
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: _notificationSound,
                  onChanged: (value) {
                    setState(() {
                      _notificationSound = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16), // Space between elements

            // Star Rating Section
            Text(
              'Rate Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    _rating > index ? Icons.star : Icons.star_border,
                    color: Colors.yellow[700],
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1; // Update rating
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 16), // Space between elements

            // Comments Section
            TextField(
              controller: _commentController, // Set the controller
              decoration: InputDecoration(
                labelText: 'Comments',
                border: OutlineInputBorder(),
                hintText: 'Share your feedback...',
              ),
              maxLines: 3, // Allow multiple lines
            ),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String comments = _commentController.text;
                  print(
                      'User Comments: $comments'); // Print comments to terminal
                  _commentController
                      .clear(); // Clear the text field after submission
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  backgroundColor: const Color.fromARGB(
                      255, 88, 221, 199), // Custom button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleIncomingNotification() {
    _playNotificationSound(); // Play sound if enabled
  }
}
