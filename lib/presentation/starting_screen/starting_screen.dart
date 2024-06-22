import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async'; // Timer için gerekli
import 'package:demo_s_application1/presentation/general_screen/general_screen.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In paketi
import 'package:http/http.dart' as http;

import 'package:demo_s_application1/core/utils/image_constant.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({Key? key}) : super(key: key);

  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late final http.Client httpClient;
  bool isAliveVisible = true;

  // Google Sign-In için değişkenler
  late GoogleSignIn _googleSignIn;
  bool _isLoggedIn = false;
  String _userEmail = '';
  String? responseData;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // Google Sign-In işlemleri için hazırlık
    _googleSignIn = GoogleSignIn(scopes: ['email']);

    _controller.forward().then((value) {
      // Alive metnini gizle
      Timer(Duration(seconds: 1), () {
        setState(() {
          isAliveVisible = false;
        });
        // Welcome metnini göster ve sayfayı değiştir
        Timer(Duration(seconds: 2), () {
          if (!_isLoggedIn) {
            _showGoogleSignInDialog(); // Google Sign-In modalını göster
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GeneralScreen()),
            );
          }
        });
      });
    });
  }

  Future<void> postEmail(String email) async {
    final String url = "http://172.22.0.1:3000/postemail";

    // POST request body
    Map<String, String> requestBody = {
      'email': email,
    };

    // Send a POST request
    final response = await http.post(
      Uri.parse(url), // Parse the URL string to a Uri object
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
      },
      body: jsonEncode(requestBody), // Encode the request body to JSON
    );

    // Check the status code of the response
    if (response.statusCode == 200) {
      // Successful request
      print('Email successfully posted');
      print(response.body); // Response body, if needed
    } else {
      // Request failed, print the error message
      print('Failed to post email: ${response.statusCode}');
    }
  }

  Future<void> _showGoogleSignInDialog() async {
    try {
      // Eğer kullanıcı daha önce giriş yaptıysa ve bu e-posta ile hesap oluşturulmuşsa,
      // doğrudan GeneralScreen'e yönlendir.
      if (_isLoggedIn && _userEmail.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GeneralScreen()),
        );
        return;
      }

      // Eğer kullanıcı daha önce giriş yapmamışsa veya hesap oluşturulmamışsa,
      // Google hesabı ile giriş yapma işlemine devam et.
      GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        setState(() {
          _isLoggedIn = true;
          _userEmail = user.email;
          Globalemail.useremail = user.email;
        });
        //buradaki email db'a aktarılacak
        print('Giriş yapılan e-posta: $_userEmail');
        postEmail(_userEmail);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GeneralScreen()),
        );
      }
    } catch (error) {
      print('Google Sign-In hatası: $error');
      // Hata durumunda kullanıcıyı uyarmak için bir snackbar gösterebilirsiniz
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0072FF),
              Color(0xFF00C6FF),
            ],
          ),
        ),
        child: Center(
          child: Opacity(
            opacity: _animation.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: isAliveVisible,
                  child: Text(
                    'Alive',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Boşluk ekledim
                Visibility(
                  visible: !isAliveVisible,
                  child: Text(
                    'Welcome \nto \nyour dreams',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
