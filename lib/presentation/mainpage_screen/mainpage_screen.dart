import 'package:demo_s_application1/presentation/general_screen/general_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainpageScreen extends StatefulWidget {
  const MainpageScreen({Key? key}) : super(key: key);

  @override
  _MainpageScreenState createState() => _MainpageScreenState();
}

class _MainpageScreenState extends State<MainpageScreen> {
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
  }

  @override
  void dispose() {
    habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F5E6),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildTitle(),
            SizedBox(height: 20),
            _buildTextField("New Habit:", habitNameController),
            SizedBox(height: 20),
            _buildDateButton("Starting Date:", startDate, true),
            SizedBox(height: 20),
            _buildDateButton("Ending Date:", endDate, false),
            SizedBox(height: 20),
            _buildTimeButton("Notification Hours:", notificationTime),
            SizedBox(height: 20),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Create New Habit",
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
        fillColor: Colors.white,
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
        backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
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
        // Save düğmesine tıklandığında GeneralScreen ekranına geçiş yap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GeneralScreen()),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        child: Text(
          "Save",
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
