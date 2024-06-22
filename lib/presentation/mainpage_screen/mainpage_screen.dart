import 'dart:convert';
import 'package:demo_s_application1/core/utils/image_constant.dart';

import 'package:flutter/material.dart';
import 'package:demo_s_application1/presentation/general_screen/general_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MainpageScreen extends StatefulWidget {
  const MainpageScreen({Key? key}) : super(key: key);

  @override
  _MainpageScreenState createState() => _MainpageScreenState();
}

class _MainpageScreenState extends State<MainpageScreen> {
  late TextEditingController habitNameController;
  late DateTime startDate;
  late DateTime endDate;
  late TimeOfDay notificationTime;

  @override
  void initState() {
    super.initState();
    habitNameController = TextEditingController();
    startDate = DateTime.now();
    endDate = DateTime.now();
    notificationTime = TimeOfDay.now();
    print(
        'burası mainpage :  useremail geldi mi buraya' + Globalemail.useremail);
  }

  @override
  void dispose() {
    habitNameController.dispose();
    super.dispose();
  }

  Future<void> addNewAim(String email, String aim, String aimDate,
      String endDay, String notification) async {
    final String url = "http://172.22.0.1:3000/addnewaim";

    // POST request body
    Map<String, String> requestBody = {
      'email': email,
      'name': aim,
      'startday': aimDate,
      'endday': endDay,
      'notification_hour': notification,
    };

    // Send a POST request
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      // Successful request
      print('Aim successfully posted');
      print(response.body); // Response body, if needed
    } else {
      // Request failed, print the error message
      print('Failed to post aim: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/back.png"), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                _buildTitle(),
                SizedBox(height: 20),
                _buildTextField("New Habit:", habitNameController),
                SizedBox(height: 20),
                _buildDateButton("Starting Date:", startDate, true),
                SizedBox(height: 20),
                _buildDateButton("Ending Date:", endDate, false),
                SizedBox(height: 20),
                _buildTimeButton("Notification Hours:", notificationTime),
                SizedBox(height: 20),
                _buildSaveButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Create New Habit",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.teal[900],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal[900]),
        filled: true,
        fillColor:
            Colors.white.withOpacity(0.8), // Opacity for better visibility
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime date, bool isStartDate) {
    return ElevatedButton(
      onPressed: () => _selectDate(context, isStartDate),
      child: Text(
        "$label ${DateFormat('dd.MM.yyyy').format(date)}",
        style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.white.withOpacity(0.8), // Opacity for better visibility
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay time) {
    return ElevatedButton(
      onPressed: _selectTime,
      child: Text(
        "$label ${time.format(context)}",
        style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.white.withOpacity(0.8), // Opacity for better visibility
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Tüm bilgileri yazdır
        _printHabitInfo();

        // Kullanıcının e-posta adresiyle addnewaim fonksiyonunu çağır
        addNewAim(
            Globalemail.useremail,
            habitNameController.text,
            DateFormat('dd.MM.yyyy').format(startDate),
            DateFormat('dd.MM.yyyy').format(endDate),
            notificationTime.format(context));

        // GeneralScreen ekranına geçiş yap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GeneralScreen()),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        child: Text(
          "Save",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: notificationTime,
    );
    if (picked != null && picked != notificationTime) {
      setState(() {
        notificationTime = picked;
      });
    }
  }

  void _printHabitInfo() {
    print("New Habit: ${habitNameController.text}");
    print("Starting Date: ${DateFormat('dd.MM.yyyy').format(startDate)}");
    print("Ending Date: ${DateFormat('dd.MM.yyyy').format(endDate)}");
    print("Notification Hours: ${notificationTime.format(context)}");
  }
}
