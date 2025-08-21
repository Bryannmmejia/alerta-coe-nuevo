import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alertacoe/helper/applicationDefault.dart';
import '../HomePage.dart';
import '../login/loginPage.txt';

var app = ApplicationDefault();

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    try {
      bool logged = await app.isLogged();
      if (logged) {
        Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePageView())));
      } else {
        Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage())));
      }
    } catch (e) {
      app.ackAlert(context, "Error", title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/splash.png'),
      ),
    );
  }
}
