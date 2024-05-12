import 'package:demo_s_application1/widgets/app_bar/appbar_trailing_button.dart';
import 'package:demo_s_application1/widgets/app_bar/custom_app_bar.dart';
import 'package:demo_s_application1/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:demo_s_application1/core/app_export.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
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
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Your Habits",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.green[900],
        ),
      ),
    );
  }

  Widget _buildHabitList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 20),
        children: [
          _buildHabitCard("Drink Water", "21 days"),
          _buildHabitCard("Quit Smoking", "21 days"),
          _buildHabitCard("Exercise", "9 days"),
          _buildHabitCard("Read a Book", "10 days"),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            progress,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomElevatedButton(
              height: 50,
              width: double.infinity,
              text: "Track Habits",
              buttonTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.white, // Metin rengini beyaz olarak ayarla
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green[900], // Arka plan rengini ayarlayalım
              ),
              onPressed: () {
                onTapTracking(context);
              },
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: CustomElevatedButton(
              height: 50,
              width: double.infinity,
              text: "Add",
              buttonTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green[900], // Arka plan rengini ayarlayalım
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

  onTapMore(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.paymentScreen);
  }

  onTapTracking(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.calendarScreen);
  }

  onTapAddNewHabit(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainpageScreen);
  }
}
