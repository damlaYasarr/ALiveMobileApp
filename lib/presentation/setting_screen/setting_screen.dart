import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

// add here users icon, email address,
// get permission for location
// notif. sound
//

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationSound = true; // Initial value
  final TextEditingController _commentController =
      TextEditingController(); // Controller for comments
  int _rating = 0; // For star rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Sound Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notification Sound',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: _notificationSound,
                  onChanged: (value) {
                    setState(() {
                      _notificationSound = value;
                      // Call your notification sound method here if needed
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
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
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
}
