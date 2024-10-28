import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:aLive/widgets/app_bar/appbar_trailing_button.dart';
import 'package:aLive/widgets/app_bar/custom_app_bar.dart';
import 'package:aLive/widgets/custom_elevated_button.dart';
import 'package:aLive/core/app_export.dart';
import 'package:google_fonts/google_fonts.dart';

class Aim {
  final String name;
  final DateTime startDay;
  final DateTime endDay;
  final int completeDaysCount;
  final int percentage;
  final int lastday;
  Aim({
    required this.name,
    required this.startDay,
    required this.endDay,
    required this.completeDaysCount,
    required this.percentage,
    required this.lastday,
  });

  factory Aim.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("dd.MM.yyyy");

    DateTime startDay = format.parse(json['startday']);
    DateTime endDay = format.parse(json['endday']);
    int totalDays = endDay.difference(startDay).inDays;
    int completeDaysCount = json['complete_days_count'];
    int percentage =
        (totalDays > 0) ? ((completeDaysCount * 100) ~/ totalDays) : 0;

    return Aim(
        name: json['name'],
        startDay: startDay,
        endDay: endDay,
        completeDaysCount: completeDaysCount,
        percentage: percentage,
        lastday: totalDays);
  }
}

class GeneralScreen extends StatefulWidget {
  GeneralScreen({Key? key}) : super(key: key);

  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  List<Aim> _aims = [];

  @override
  void initState() {
    super.initState();

    listAllAims(Globalemail.useremail);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sayfa her açıldığında bu metod çağrılır
    listAllAims(Globalemail.useremail);
  }

  void refreshaim(String email) {
    listAllAims(email);
  }

  Future<void> deleteHabit(String email, String aimName) async {
    final Uri url = Uri.parse('http://192.168.1.102:3000/deletehabit');

    // Construct the URL with query parameters
    final String queryParameters = '?email=$email&name=$aimName';
    final Uri finalUrl = Uri.parse('$url$queryParameters');

    // Make the DELETE request
    try {
      final response = await http.delete(
        finalUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Check if the request was successful (status code 200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Remove the deleted habit from _aims list and update the UI
        setState(() {
          _aims.removeWhere((aim) => aim.name == aimName);
        });
        print('Habit deletion request successful');
      } else {
        print('Failed to delete habit: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during habit deletion request: $e');
    }
  }

  Future<void> listAllAims(String email) async {
    final String url = "http://192.168.1.102:3000/listallAims?email=" + email;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> aimsJson = json.decode(utf8.decode(response.bodyBytes));
        List<Aim> aims = aimsJson.map((json) => Aim.fromJson(json)).toList();

        setState(() {
          _aims = aims;
        });

        print('Aims successfully retrieved');
      } else {
        print('Failed to retrieve aims: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Background image
          Container(
            width: MediaQuery.of(context)
                .size
                .width, // Set width to match screen width
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: 15),
                _buildHabitList(context),
                SizedBox(height: 9),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 57.h,
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeneralScreen(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: 0.0), // Adjust this value to move the text higher
                child: Text(
                  'alive',
                  style: GoogleFonts.pacifico(
                    fontSize: 35,
                  ),
                ),
              ),
            ),
            SizedBox(width: 110),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppbarTrailingButton(
              margin: EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.v),
              onPressed: () {
                onTapMore(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Habits",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
          SizedBox(height: 10),
          _buildAutoHabitCalendar(),
        ],
      ),
    );
  }

  Widget _buildAutoHabitCalendar() {
    DateTime today = DateTime.now();
    List<DateTime> nextFourDays =
        List.generate(4, (index) => today.add(Duration(days: index)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(nextFourDays.length, (index) {
        String dayLabel = DateFormat('EEEE')
            .format(nextFourDays[index]); // 'Wednesday', 'Thursday', etc.
        String dayNumber =
            DateFormat('d').format(nextFourDays[index]); // '15', '16', etc.

        bool isToday = index == 0; // First day is today

        return Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isToday ? Colors.green[100] : Colors.transparent,
            border: isToday ? Border.all(color: Colors.green, width: 2) : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Text(
                dayLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                dayNumber,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHabitList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: _aims.isEmpty
          ? Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 249, 252, 215),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'This is the habit tracking application!\n'
                  'Our aim is to help you gain habits\n'
                  'for the dream version of yourself.\n',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _aims.length,
              itemBuilder: (context, index) {
                Aim aim = _aims[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildHabitCard(aim),
                );
              },
            ),
    );
  }

  Widget _buildHabitCard(Aim aim) {
    int completionPercentage = aim.percentage;
    double completedWidth = 150 * (completionPercentage / 100);

    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9), // Kart rengi
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aim.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Duration: ${aim.lastday} days",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal[700],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: completedWidth,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "$completionPercentage%",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              deleteHabit(Globalemail.useremail, aim.name);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: Column(
        children: [
          // First Button: "Go to history"
          CustomElevatedButton(
            height: 50,
            width: double.infinity,
            text: "Go to History",
            buttonTextStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[900],
            ),
            onPressed: () {
              goHistoryPage(context);
            },
          ),
          SizedBox(height: 20), // Space between buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomElevatedButton(
                  height: 50,
                  width: double.infinity,
                  text: "Track Habits",
                  buttonTextStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[900],
                  ),
                  onPressed: () {
                    onTapTracking(context);
                  },
                ),
              ),
              SizedBox(width: 10), // Space between buttons
              Expanded(
                child: CustomElevatedButton(
                  height: 50,
                  width: double.infinity,
                  text: "Add",
                  buttonTextStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[900],
                  ),
                  onPressed: () {
                    onTapAddNewHabit(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onTapMore(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.feedbackscreen);
  }

  void refreshpage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.generalScreen);
  }

  void onTapTracking(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.calendarScreen);
  }

  void onTapAddNewHabit(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addhabitscreen);
  }

  void goHistoryPage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.overviewScreen);
  }
}
