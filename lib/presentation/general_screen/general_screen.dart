import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:demo_s_application1/core/utils/image_constant.dart';
import 'package:demo_s_application1/widgets/app_bar/appbar_trailing_button.dart';
import 'package:demo_s_application1/widgets/app_bar/custom_app_bar.dart';
import 'package:demo_s_application1/widgets/custom_elevated_button.dart';
import 'package:demo_s_application1/core/app_export.dart';

class Aim {
  final String name;
  final DateTime startDay;
  final DateTime endDay;
  final int completeDaysCount;
  final int percentage;
  Aim({
    required this.name,
    required this.startDay,
    required this.endDay,
    required this.completeDaysCount,
    required this.percentage,
  });

  factory Aim.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("dd.MM.yyyy");

    DateTime startDay = format.parse(json['startday']);
    DateTime endDay = format.parse(json['endday']);
    int totalDays = endDay.difference(startDay).inDays;
    int completeDaysCount = json['complete_days_count'];

    int percentage =
        totalDays != 0 ? ((completeDaysCount / totalDays) * 100).toInt() : 0;

    return Aim(
        name: json['name'],
        startDay: startDay,
        endDay: endDay,
        completeDaysCount: completeDaysCount,
        percentage: percentage);
  }
}

class GeneralScreen extends StatefulWidget {
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

  Future<void> listAllAims(String email) async {
    final String url = "http://172.22.0.1:3000/listallAims?email=" + email;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: 20),
                _buildHabitList(context),
                SizedBox(height: 30),
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
            Text(
              'alive',
              style: TextStyle(
                color: const Color.fromARGB(255, 12, 12, 12),
                fontSize: 40,
                fontFamily: "carolingia",
              ),
            ),
            SizedBox(width: 15),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppbarTrailingButton(
                margin: EdgeInsets.symmetric(horizontal: 27.h, vertical: 8.v),
                onPressed: () {
                  onTapMore(context);
                },
              ),
            ],
          ),
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
    // Generate calendar for the next 4 days starting today
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
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
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
    double completionPercentage =
        aim.percentage / 100; // Tamamlanma yüzdesi hesapla
    double completedWidth = 150 * completionPercentage; // Tamamlanan genişlik

    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(20),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            aim.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "${aim.percentage} % completed",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
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
          SizedBox(width: 10),
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
    );
  }

  void onTapMore(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.paymentScreen);
  }

  void onTapTracking(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.calendarScreen);
  }

  void onTapAddNewHabit(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainpageScreen);
  }
}
