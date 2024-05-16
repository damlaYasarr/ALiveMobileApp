import 'package:demo_s_application1/widgets/app_bar/appbar_trailing_button.dart';
import 'package:demo_s_application1/widgets/app_bar/custom_app_bar.dart';
import 'package:demo_s_application1/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:demo_s_application1/core/app_export.dart';
import 'package:intl/intl.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({Key? key}) : super(key: key);
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
        AppbarTrailingButton(
          margin: EdgeInsets.symmetric(horizontal: 27.h, vertical: 8.v),
          onPressed: () {
            onTapMore(context);
          },
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
    // Bugünden itibaren 4 günlük takvim
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

        bool isToday = index == 0; // İlk gün bugündür

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
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 20),
        children: [
          // get from db
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildHabitCard("Drink Water", "21 days"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildHabitCard("Quit Smoking", "21 days"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildHabitCard("Exercise", "9 days"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildHabitCard("Read a Book", "10 days"),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(String title, String progress) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(20),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
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
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            progress,
            style: TextStyle(
              fontSize: 14,
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
