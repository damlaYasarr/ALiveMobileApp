import 'dart:convert';
import 'package:aLive/core/utils/image_constant.dart';
import 'package:aLive/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Aim {
  final String name;
  final DateTime startDay;
  final DateTime endDay;
  final int completeDaysCount;
  final int percentage;
  final int lastDay;

  Aim({
    required this.name,
    required this.startDay,
    required this.endDay,
    required this.completeDaysCount,
    required this.percentage,
    required this.lastDay,
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
      lastDay: totalDays,
    );
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
        "http://192.168.1.64:3000/listexpiredhabits?email=" + email;

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
  void initState() {
    super.initState();
    listExpiredAims(Globalemail.useremail);
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
                  image: AssetImage("assets/images/back.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                AppBar(
                  title: Text(
                    S.of(context).SeeyourExpiredHabit,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green[900],
                  elevation: 0,
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildExpiredHabits(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiredHabits(BuildContext context) {
    return ListView.builder(
      itemCount: _aims.length,
      itemBuilder: (context, index) {
        return _buildHabitCard(_aims[index]);
      },
    );
  }

  Widget _buildHabitCard(Aim aim) {
    int completionPercentage = aim.percentage;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 197, 197, 197).withOpacity(0.8),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "${DateFormat('dd.MM.yyyy').format(aim.startDay)} - ${DateFormat('dd.MM.yyyy').format(aim.endDay)}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "$completionPercentage% ${S.of(context).Completed}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                width: 150 *
                    (completionPercentage /
                        100), // Dynamic width based on percentage
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
