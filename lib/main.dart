import 'dart:async';

import 'package:alertacoe/application_localizations.dart';
// Usa el splash correcto, si splashPage.dart no existe, cambia el import:
import 'package:alertacoe/views/login/splashPage.dart';
// Si tu splash es splash3Page.dart, usa:
// import 'package:alertacoe/views/login/splash3Page .dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'helper/constants.dart';
import 'helper/networkHelper.dart';
import 'helper/globalState.dart';

void main() => runApp(MainView());

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MainView> {
  late StreamSubscription _connectionChangeStream;
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    init();
  }

  Future<void> init() async {
    try {
      messaging.getToken().then((value) {
        print(value);
        messaging.subscribeToTopic("coealert");
      });
      NetworkHelper connectionStatus = NetworkHelper.getInstance();
      _connectionChangeStream =
          connectionStatus.connectionChange.listen(connectionChanged);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void connectionChanged(dynamic hasConnection) {
    // Puedes implementar lógica aquí si lo necesitas
  }

  @override
  void dispose() {
    _connectionChangeStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    GlobalState.getInstance().appBuildContext = context;
    return MaterialApp(
      title: "COE Alertas",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightBlueColor),
        appBarTheme: AppBarTheme(
          color: kPrimaryColor,
        ),
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyLarge: GoogleFonts.montserrat(textStyle: textTheme.bodyLarge),
        ),
      ),
      home: SplashScreen(),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        ApplicationLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale?.languageCode) {
            return supportedLocaleLanguage;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}