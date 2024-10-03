import 'package:demo_s_application1/core/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For handling JSON
import 'package:http/http.dart' as http; // For making HTTP requests

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackDetailController =
      TextEditingController();

  String? feedbackText; // To store the feedback text

  // Function to get feedback from the API
  Future<void> getFeedBack() async {
    final Uri url = Uri.parse(
        'http://172.18.0.1:3000/getfeedback?email=' + Globalemail.useremail);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // If the request is successful, store the feedback text
        setState(() {
          feedbackText = json.decode(response.body)['ai_feedback'];
        });
      } else {
        throw Exception('Failed to load feedback');
      }
    } catch (e) {
      print("Error fetching feedback: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/back.png"), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    'Information',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green[900],
                  elevation: 0,
                ),

                // New Button: "Would you like to see your progress?"
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for the progress button
                    },
                    child: Text('Would you like to see your progress?'),
                  ),
                ),

                // Existing Button: Trigger Get Feedback
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      getFeedBack(); // Fetch feedback from the server
                    },
                    child: Text('Get Feedback'),
                  ),
                ),

                // Display the feedback if available
                if (feedbackText != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      feedbackText!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
