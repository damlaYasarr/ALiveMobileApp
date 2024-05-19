import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:demo_s_application1/widgets/app_bar/custom_app_bar.dart';
import 'package:demo_s_application1/core/app_export.dart';
import 'dart:convert';

class Active {
  final List<DateTime> completedDays;
  final int id;

  Active({
    required this.completedDays,
    required this.id,
  });

  factory Active.fromJson(Map<String, dynamic> json) {
    List<DateTime> completedDays = [];

    if (json['complete_days'] != null && json['complete_days'] != '') {
      List<String> completedDaysStringList =
          json['complete_days'].replaceAll(RegExp(r'[{} ]'), '').split(',');
      for (String day in completedDaysStringList) {
        List<String> dateParts = day.trim().split('.');
        int dayInt = int.parse(dateParts[0]);
        int monthInt = int.parse(dateParts[1]);
        int yearInt = int.parse(dateParts[2]);
        completedDays.add(DateTime(yearInt, monthInt, dayInt));
      }
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
  final Set<DateTime> _completedHabits = {
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 3)),
  };

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
    final String url = "http://172.22.0.1:3000/activedays?email=" + email;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> aimsJson = json.decode(utf8.decode(response.bodyBytes));
        print('Aims successfully retrieved:');
        print(aimsJson);
        List<Active> retrievedActives =
            aimsJson.map((json) => Active.fromJson(json)).toList();
        print('Retrieved actives:');
        print(retrievedActives);
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
                Text(
                  '${_calculateCompletionPercentage().toStringAsFixed(2)}%',
                  style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 70, 128)),
                ),
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
                      if (actives.any((active) => active.completedDays.any(
                          (completedDay) => isSameDay(completedDay, day)))) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle().copyWith(color: Colors.black),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateCompletionPercentage() {
    // Seçilen ayın son gününü bulmak için
    final lastDayOfMonth =
        DateTime(_selectedDay.year, _selectedDay.month + 1, 0).day;

    // Seçilen aydaki tamamlanmış aktif gün sayısını bulmak için
    final completedDaysInMonth = actives.fold<int>(
        0,
        (count, active) =>
            count +
            active.completedDays
                .where((day) => day.month == _selectedDay.month)
                .length);

    // Yüzdeyi hesaplamak için
    final percentage = (completedDaysInMonth / lastDayOfMonth) * 100;

    // Eğer yüzde NaN ise 0 olarak dön
    return percentage.isNaN ? 0 : percentage;
  }
}
