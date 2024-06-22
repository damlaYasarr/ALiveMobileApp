import 'package:flutter/material.dart';
import 'package:demo_s_application1/core/app_export.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({Key? key}) : super(key: key);

  // Payment details controller
  final TextEditingController _paymentDetailController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Information',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green[900],
                elevation: 0,
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            content: Container(
                              width: 300,
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Understructure Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Here is some information explaining why this understructure is important.',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('Here is UNDERSTRUCTURE why?'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
