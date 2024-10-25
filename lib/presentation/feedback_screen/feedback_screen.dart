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
  String? feedbackText; // To store the feedback text
  bool isLoading = false; // To indicate loading state
  bool showGetFeedbackButton =
      false; // To control visibility of the Get Feedback button

  // Function to get feedback from the API
  Future<void> getFeedBack() async {
    setState(() {
      isLoading = true; // Set loading to true before making the request
    });

    final Uri url = Uri.parse(
        'http://192.168.1.102:3000/getfeedback?email=' + Globalemail.useremail);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // If the request is successful, store the feedback text
        setState(() {
          feedbackText = json.decode(response.body)['ai_feedback'];
          isLoading = false; // Set loading to false after getting the response
        });
      } else {
        throw Exception('Failed to load feedback');
      }
    } catch (e) {
      print("Error fetching feedback: $e");
      setState(() {
        isLoading = false; // Set loading to false if there's an error
        feedbackText = "An error occurred while fetching feedback.";
      });
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

                // Button: "Would you like to see your progress?"
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundColor: Colors.green, // Text color
                          side: BorderSide(
                            color: Colors.green, // Outline color

                            width: 3, // Outline width increased
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          textStyle: TextStyle(
                            fontSize: 24, // Increased font size
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showGetFeedbackButton =
                                true; // Show Get Feedback button
                          });
                        },
                        child: Text('Would you like to see your progress?'),
                      ),
                      SizedBox(height: 20), // Spacing between button and arrow
                      Icon(
                        Icons.arrow_drop_down, // Downward arrow icon
                        size: 64, // Increased icon size
                        color: Colors.green, // Icon color
                      ),
                    ],
                  ),
                ),

                // Conditional rendering of the "Get Feedback" button
                if (showGetFeedbackButton)
                  Padding(
                    padding: const EdgeInsets.all(25.0), // Increased padding
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green, // Background color
                        padding: EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40), // Increased padding
                        textStyle: TextStyle(
                          fontSize: 24, // Increased font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      onPressed: () {
                        getFeedBack(); // Fetch feedback from the server
                      },
                      child: Text('Get Feedback'),
                    ),
                  ),

                // Display loading message while waiting for feedback
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Please wait, loading your feedback...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Display the feedback if available
                if (feedbackText != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      feedbackText == ""
                          ? "Henüz eklediğiniz alışkanlıklarda tamamen null değer olduğu için dönüş alamazsınız."
                          : feedbackText!,
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
