import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:demo_s_application1/core/app_export.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
    int lastday = totalDays;
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

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<Aim> _aims = [];
  Future<void> listExpiredAims(String email) async {
    final String url =
        "http://172.18.0.1:3000/listexpiredhabits?email=" + email;

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
    return SafeArea(
      child: Scaffold(
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
            Column(
              children: [
                AppBar(
                  title: Text(
                    'List your expired habits',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green[900],
                  elevation: 0,
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.0),
                        _buildExpiredHabits(context),
                        Spacer(),
                        // it listed
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildExpiredHabits(BuildContext context) {}
  Widget _buildHabitCard(Aim aim) {
    // fix here !! math calculation is false
    int completionPercentage = aim.percentage; // here is calculated days
    int completedWidth = (150 * (completionPercentage / 100)).round();

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                " ${aim.startDay}  - ${aim.endDay}",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${completionPercentage} % completed",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
