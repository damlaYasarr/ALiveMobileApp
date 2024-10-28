import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:aLive/core/app_export.dart';
import 'dart:convert';

// Active class representing the habit tracking data
class Active {
  final List<DateTime> completedDays;
  final int id;

  Active({
    required this.completedDays,
    required this.id,
  });

  factory Active.fromJson(Map<String, dynamic> json) {
    List<DateTime> completedDays = [];

    if (json['complete_days'] != null && json['complete_days'].isNotEmpty) {
      List<String> completedDaysStringList =
          json['complete_days'].replaceAll(RegExp(r'[{} ]'), '').split(',');
      completedDays = completedDaysStringList.map((day) {
        List<String> dateParts = day.trim().split('.');
        return DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]),
            int.parse(dateParts[0]));
      }).toList();
    }

    return Active(
      completedDays: completedDays,
      id: json['id'],
    );
  }

  @override
  String toString() {
    return 'Active(id: $id, completedDays: $completedDays)';
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarFormat _calendarFormat;
  List<Active> actives = [];
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    getActives(Globalemail.useremail);
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    initializeDateFormatting();
  }

  Future<void> getActives(String email) async {
    final String url = "http://192.168.1.102:3000/activedays?email=$email";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> aimsJson = json.decode(utf8.decode(response.bodyBytes));
        List<Active> retrievedActives =
            aimsJson.map((json) => Active.fromJson(json)).toList();
        setState(() {
          actives = retrievedActives;
        });
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
        appBar: AppBar(
          title: Text(
            'Track your habits',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green[900],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.0),

                // Circular background for the percentage text
                Container(
                  width: 150.0, // Set the width of the circular container
                  height: 150.0, // Set the height of the circular container
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Make the container circular
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 150, 136), // Start color
                        Color.fromARGB(255, 0, 70, 128), // End color
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment:
                      Alignment.center, // Center the text inside the circle
                  child: Text(
                    '${_calculateCompletionPercentage().toInt()}%',
                    style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .white, // Change text color to white for better contrast
                    ),
                  ),
                ),

                SizedBox(height: 30.0),

                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      bool isActive = actives.any((active) => active
                          .completedDays
                          .any((completedDay) => isSameDay(completedDay, day)));

                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color:
                              isActive ? Colors.teal[300] : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              spreadRadius: 2.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.orange[300],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              spreadRadius: 2.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                      color: const Color.fromARGB(
                          255, 255, 105, 180), // Pink color for header
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0, // Larger size for header text
                    ),
                    formatButtonVisible:
                        false, // Hide the format button if not needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purpleAccent,
                          Colors.blueAccent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color:
                          Colors.deepOrange, // Change to your preferred color
                      fontWeight: FontWeight.bold,
                    ),
                    weekendStyle: TextStyle(
                      color: const Color.fromARGB(
                          255, 24, 95, 117), // Change weekend day color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 30.0),

                // Call to build the line chart
                _buildLineChart(),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    List<FlSpot> spots = [];

    // Get the total days in the selected month
    int daysInMonth =
        DateTime(_selectedDay.year, _selectedDay.month + 1, 0).day;

    // Create a list to count completed tasks for each day
    List<int> dailyCounts = List.filled(daysInMonth, 0);

    // Count completed tasks per day
    for (var active in actives) {
      for (var completedDay in active.completedDays) {
        if (completedDay.year == _selectedDay.year &&
            completedDay.month == _selectedDay.month) {
          dailyCounts[
              completedDay.day - 1]++; // Increment the count for that day
        }
      }
    }

    // Create FlSpot for each day
    for (int i = 0; i < daysInMonth; i++) {
      spots.add(FlSpot(i.toDouble(), dailyCounts[i].toDouble()));
    }

    if (spots.isEmpty) {
      return Center(child: Text('No data available'));
    }

    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    double minY = 0.0;

    // Ensure minY and maxY are valid
    if (minY == maxY) {
      maxY += 1; // Ensure there's a difference
    }

    return Container(
      height: 300, // Set a specific height for the chart
      padding: EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 16.0), // Increased padding
      child: Column(
        children: [
          Text(
            'Achievement Graph',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              decoration: TextDecoration.underline, // Underline for emphasis
            ),
          ),
          SizedBox(height: 9.0), // Space between title and chart
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: false), // Enable vertical grid lines
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false), // Hide left titles
                  ),
                  topTitles: AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false), // Hide top titles
                  ),
                  rightTitles: AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false), // Hide right titles
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.transparent),
                    left: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                    right: BorderSide(color: Colors.transparent),
                  ),
                ),
                minX: 0,
                maxX: daysInMonth.toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blue,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 6.0), // Space between chart and month name
          Text(
            DateFormat('MMMM').format(_selectedDay), // Display the month's name
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [
                    Colors.purpleAccent,
                    Colors.blueAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(
                    Rect.fromLTWH(0, 0, 200, 70)), // Adjust the Rect as needed
            ),
          ),
        ],
      ),
    );
  }

  double _calculateCompletionPercentage() {
    final lastDayOfMonth =
        DateTime(_selectedDay.year, _selectedDay.month + 1, 0).day;
    final completedDaysInMonth = actives.fold<int>(
        0,
        (count, active) =>
            count +
            active.completedDays
                .where((day) => day.month == _selectedDay.month)
                .length);

    final percentage = (completedDaysInMonth / lastDayOfMonth) * 100;
    return percentage.isNaN
        ? 0
        : percentage.clamp(0, 100); // Clamping the value between 0 and 100
  }
}
