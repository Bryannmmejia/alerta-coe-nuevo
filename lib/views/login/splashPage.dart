import 'dart:async';
import 'package:alertacoe/helper/constants.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:flutter/material.dart';
import 'package:alertacoe/helper/applicationDefault.dart';
import '../../views/HomePage.dart';
import 'loginPage.dart';

var app = ApplicationDefault();

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    try {
      bool logged = await app.isLogged();
      if (logged) {
        var prefs = await app.getPreference();
        List<String>? logonResultString =
            prefs.getStringList(GlobalState.getInstance().logonDataKey);
        List<dynamic> logonResult = logonResultString != null ? List<dynamic>.from(logonResultString) : [];
        GlobalState.getInstance().logonResult = LogonData(
          provinceId: logonResult[2],
          fullName: logonResult[3],
          token: logonResult[1],
          username: logonResult[0],
          userType: "app",
          provinceName: logonResult[4],
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomePageView()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage(title: "Login")));
      }
    } catch (e) {
      app.ackAlert(context, "Error", title: '');
    }
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Image.asset(
                  'assets/images/logo-coe-96x96.png',
                  height: 60.0,
                  fit: BoxFit.scaleDown,
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Alerta COE",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
