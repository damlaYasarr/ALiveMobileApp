import 'dart:async';
import 'dart:convert';
import 'package:aLive/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:aLive/widgets/app_bar/custom_app_bar.dart';
import 'package:aLive/widgets/custom_elevated_button.dart';
import 'package:aLive/core/app_export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isMarkedForDeletion = false;
  @override
  void initState() {
    super.initState();

    listAllAims(Globalemail.useremail);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // call these method to refresh the page
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
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

  Future<void> ApproveTheHabit(String name, String email, String date) async {
    final Uri url = Uri.parse('http://192.168.1.102:3000/approvaltime');

    final Map<String, String> requestBody = {
      "email": email,
      "name": name,
      "complete_days": date,
    };

    String body = json.encode(requestBody);

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Habit approval request successful');

        print('Failed to approve habit: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during habit approval request: $e');
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
                padding: EdgeInsets.only(top: 0.0),
                child: Text(
                  'alive',
                  style: GoogleFonts.pacifico(fontSize: 35),
                ),
              ),
            ),
            SizedBox(width: 110), // Space adjustment
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.feedback),
              onPressed: () {
                onTapMore(context);
              },
            ),
            SizedBox(width: 1.h), // Adjusted spacing for better separation
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                gotosetting(context);
              },
            ),
          ],
        )
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
            S.of(context).YourHabits,
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

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Widget _buildHabitList(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isConnected(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator()); // yüklenirken gösterilecek
        }
        bool isConnected = snapshot.data!;

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: !isConnected
              ? Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 249, 252, 215),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      S.of(context).InternetProblem,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _aims.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 249, 252, 215),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          S.of(context).Startsomewhere,
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.center,
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
      },
    );
  }

  void deleteHabitWithDelay(String email, Aim aim) {
    Timer(Duration(seconds: 3), () {
      setState(() {
        _aims.remove(aim);
      });
      deleteHabit(email, aim.name);
      isMarkedForDeletion = false;
    });
  }

  Widget _buildHabitCard(Aim aim) {
    int completionPercentage = aim.percentage;
    double completedWidth = 150 * (completionPercentage / 100);
    bool isMarkedForDeletion = false;
    bool isChecked = false;
    String todayDate = DateFormat('dd.MM.yyyy').format(DateTime.now());

    return StatefulBuilder(
      builder: (context, setState) {
        // Checkbox durumunu yüklemek için bir fonksiyon
        Future<void> _loadCheckboxState() async {
          final prefs = await SharedPreferences.getInstance();
          String lastApprovedDate = prefs.getString(aim.name) ?? "";

          // Eğer son onay tarihi bugüne eşitse, checkbox'ı disable et
          if (lastApprovedDate == todayDate) {
            setState(() {
              isChecked = true;
            });
          }
        }

        // Checkbox durumunu kaydetmek için bir fonksiyon
        Future<void> _saveCheckboxState() async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(aim.name, todayDate);
        }

        // Sayfa yüklendiğinde checkbox durumunu kontrol et
        _loadCheckboxState();

        return Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFF9F9F9),
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
                        decoration: isMarkedForDeletion
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      " ${S.of(context).Duration}: ${aim.lastday} ${S.of(context).Days}",
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
              if (!isChecked) // Checkbox'ı sadece bugün onaylanmadıysa göster
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                      if (isChecked) {
                        ApproveTheHabit(
                            aim.name, Globalemail.useremail, todayDate);
                        _saveCheckboxState(); // Onaylandığında durumu kaydet
                        refreshpage(context);
                      }
                    });
                  },
                ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    isMarkedForDeletion = true;
                  });
                  deleteHabitWithDelay(Globalemail.useremail, aim);
                },
              ),
            ],
          ),
        );
      },
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
            text: S.of(context).GoToHistory,
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
                  text: S.of(context).TrackYourDevelopment,
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
                  text: S.of(context).Add,
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

  void gotosetting(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.settingScreen);
  }
}
