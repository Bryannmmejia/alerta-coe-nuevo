import 'package:alertacoe/views/webview/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';
import '../helper/globalState.dart';

enum ConfirmAction { CANCEL, ACCEPT }
enum Departments { Production, Research, Purchasing, Marketing, Accounting }

class ApplicationDefault {
  static final ApplicationDefault _instance = ApplicationDefault._internal();

  factory ApplicationDefault() {
    return _instance;
  }

  ApplicationDefault._internal();

  Future<SharedPreferences> getPreference() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> isLogged() async {
    SharedPreferences prefs = await getPreference();
    return (prefs.getBool(GlobalState.getInstance().logonKey) ?? false);
  }

  var regEmail = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  Future ackAlert(BuildContext context, String message, {required String title}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future asyncConfirmDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset settings?'),
          content: const Text(
              'This will reset your device to its default factory settings.'),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            TextButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future asyncSimpleDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Departments '),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Production);
                },
                child: const Text('Production'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Research);
                },
                child: const Text('Research'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Purchasing);
                },
                child: const Text('Purchasing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Marketing);
                },
                child: const Text('Marketing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Accounting);
                },
                child: const Text('Accounting'),
              )
            ],
          );
        });
  }

  Future asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter current team'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Team Name', hintText: 'eg. Juventus F.C.'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }

  navigateToWithWidget(BuildContext pContext, String header, Widget _child) {
    Navigator.of(pContext).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(header),
          ),
          body: Material(
            child: Container(
              // The blue background emphasizes that it's a new route.
              color: Colors.white,
              padding: const EdgeInsets.all(0),
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: _child,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  navigateToWebView(BuildContext pContext, String url, String title) {
    Navigator.of(pContext)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Material(
          child: Container(
            // The blue background emphasizes that it's a new route.
            color: Colors.white,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: WebViewPage(url: url),
              ),
            ),
          ),
        ),
      );
    }));
  }

  IconData getWeatherIcon(String icon) {
    IconData _icon = Icons.cloud_outlined;
    String n = icon;
    const String clearDay = "clear-day";
    const String clearNight = "clear-night";
    const String rain = "rain";
    const String snow = "snow";
    const String sleet = "sleet";
    const String wind = "wind";
    const String fog = "fog";
    const String cloudy = "cloudy";
    const String partyCloudyDay = "partly-cloudy-day";
    const String partyCloudyNight = "partly-cloudy-night";
    switch (n) {
      case clearDay:
        _icon = WeatherIcons.day_sunny;
        break;
      case clearNight:
        _icon = WeatherIcons.night_clear;
        break;
      case rain:
        _icon = WeatherIcons.rain;
        break;
      case snow:
        _icon = WeatherIcons.snow;
        break;
      case sleet:
        _icon = WeatherIcons.sleet;
        break;
      case wind:
        _icon = WeatherIcons.wind;
        break;
      case fog:
        _icon = WeatherIcons.fog;
        break;
      case cloudy:
        _icon = WeatherIcons.cloudy;
        break;
      case partyCloudyNight:
        _icon = WeatherIcons.night_cloudy;
        break;
      case partyCloudyDay:
        _icon = WeatherIcons.day_cloudy;
        break;
      default:
        break;
    }
    return _icon;
  }
}
