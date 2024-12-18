import 'dart:convert';
import 'package:aLive/core/utils/image_constant.dart';
import 'package:aLive/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:aLive/presentation/general_screen/general_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddHbabitScreen extends StatefulWidget {
  const AddHbabitScreen({Key? key}) : super(key: key);

  @override
  _MainpageScreenState createState() => _MainpageScreenState();
}

class _MainpageScreenState extends State<AddHbabitScreen> {
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
    final String url = "http://192.168.1.102:3000/addnewaim";

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

    if (response.statusCode == 200) {
      // Successful request
      print('Aim successfully posted');
      print(response.body);
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
                _buildTextField(S.of(context).NewHabit, habitNameController),
                SizedBox(height: 20),
                _buildDateButton(S.of(context).StartingDate, startDate, true),
                SizedBox(height: 20),
                _buildDateButton(S.of(context).EndingDate, endDate, false),
                SizedBox(height: 20),
                _buildTimeButton(S.of(context).NotifHour, notificationTime),
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
      S.of(context).CreateNewHabit,
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
        _printHabitInfo();
        String _formatTime(TimeOfDay time) {
          final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
          final minute = time.minute.toString().padLeft(2, '0');
          final suffix = time.hour >= 12 ? 'PM' : 'AM';
          return '$hour:$minute $suffix';
        }

        String formattedNotificationTime = _formatTime(notificationTime);

        addNewAim(
            Globalemail.useremail,
            habitNameController.text,
            DateFormat('dd.MM.yyyy').format(startDate),
            DateFormat('dd.MM.yyyy').format(endDate),
            formattedNotificationTime);

        // GeneralScreen ekranına geçiş yap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GeneralScreen()),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        child: Text(
          S.of(context).Save,
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
