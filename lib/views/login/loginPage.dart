import 'dart:convert';
import 'dart:io';

import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/constants.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/myWidgets.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/views/login/recoverPage.dart';
import 'package:alertacoe/views/login/signupPage.dart';
import 'package:alertacoe/views/widget/bezierContainer.dart';
import 'package:flutter/material.dart';
import '../../application_localizations.dart';
import '../HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

var wget = MyWidgets();
var app = ApplicationDefault();
var _http = HttpRequestHelper();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<dynamic> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // El usuario canceló el login
        return;
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      if (googleSignInAuthentication.idToken == null ||
          googleSignInAuthentication.accessToken == null) {
        app.ackAlert(context, "No se pudo obtener el token de Google.", title: '');
        return;
      }

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      var authResult = await _auth.signInWithCredential(credential);
      var _user = authResult.user;
      if (_user == null) {
        app.ackAlert(context, "No se pudo obtener el usuario.", title: '');
        return;
      }
      assert(!_user.isAnonymous);
      assert(await _user.getIdToken() != null);
      var currentUser = _auth.currentUser;
      assert(_user.uid == currentUser?.uid);

      var obj = {
        'province_id': '32',
        'provinceName': 'Santo Domingo',
        'username': _user.email ?? '',
        'names': (_user.displayName ?? '').toUpperCase(),
        'phone': _user.phoneNumber ?? '',
        'password': '123456',
        'lang': ApplicationLocalizations.of(context)?.appLocale,
        'platform': Platform.operatingSystem,
        'from': 'gmail'
      };
      var response = await _http.postRequest("security/users", obj,
          token: "C-79851-ltjoiai-Cx33@@-86667227");
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        GlobalState.getInstance().logonResult = LogonData(
          provinceId: result.data['province_id'].toString(),
          fullName: result.data['names'],
          token: result.data['token'],
          username: result.data['username'],
          userType: result.data['userType'],
          provinceName: result.data['provinceName'],
        );
        var prefs = await app.getPreference();
        List<String> logon = [
          result.data['username'],
          result.data['token'],
          result.data['province_id'].toString(),
          result.data['names'],
          result.data['provinceName'],
        ];
        prefs.setStringList(GlobalState.getInstance().logonDataKey, logon);
        await prefs.setBool(GlobalState.getInstance().logonKey, true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePageView()));
      } else {
        app.ackAlert(context, result.message, title: '');
      }
    } catch (e) {
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> signInAnonymous(String email) async {
    try {
      var obj = {
        'province_id': '32',
        'provinceName': 'Santo Domingo',
        'username': email,
        'names': "Anonymous",
        'phone': "",
        'password': '123456',
        'lang': ApplicationLocalizations.of(context)?.appLocale,
        'platform': Platform.operatingSystem,
        'from': 'anonymous'
      };
      var response = await _http.postRequest("security/users", obj,
          token: "C-79851-ltjoiai-Cx33@@-86667227");
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        GlobalState.getInstance().logonResult = LogonData(
          provinceId: result.data['province_id'].toString(),
          fullName: result.data['names'],
          token: result.data['token'],
          username: result.data['username'],
          userType: result.data['userType'],
          provinceName: result.data['provinceName'],
        );
        var prefs = await app.getPreference();
        List<String> logon = [
          result.data['username'],
          result.data['token'],
          result.data['province_id'].toString(),
          result.data['names'],
          result.data['provinceName'],
        ];
        prefs.setStringList(GlobalState.getInstance().logonDataKey, logon);
        await prefs.setBool(GlobalState.getInstance().logonKey, true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePageView()));
      } else {
        app.ackAlert(context, result.message, title: '');
      }
    } catch (e) {
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  void fnLogin() async {
    try {
      String email = emailController.text;
      if (email.isEmpty) {
        app.ackAlert(
            context,
            ApplicationLocalizations.of(context)!
                .translate("login_text_provide_email") ?? "Please provide your email", title: '');
        return;
      }

      if (!app.regEmail.hasMatch(email)) {
        app.ackAlert(
            context,
            ApplicationLocalizations.of(context)!
                .translate("login_text_invalid_email") ?? "Invalid email", title: '');
        return;
      }
      if (passwordController.text.isEmpty) {
        app.ackAlert(
            context,
            ApplicationLocalizations.of(context)
                ?.translate("login_text_provide_password") ?? "Please provide your password", title: '');
        return;
      }
      wget.onLoading(
          context, ApplicationLocalizations.of(context)!.translate("wait_text") ?? "Por favor espere");
      Map<dynamic, dynamic> obj = {
        'username': email,
        'password': passwordController.text,
        'lang': ApplicationLocalizations.of(context)?.appLocale ?? 'es',
        'isWeb': false
      };
      var jon = jsonEncode(obj);
      var response =
          await _http.loginRequest("authentication/authentication", jon, token: '');
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        GlobalState.getInstance().logonResult = LogonData(
          provinceId: result.data['province_id'].toString(),
          fullName: result.data['names'],
          token: result.data['token'],
          username: result.data['username'],
          userType: "app",
          provinceName: result.data['provinceName'],
        );
        var prefs = await app.getPreference();
        List<String> logon = [
          result.data['username'],
          result.data['token'],
          result.data['province_id'].toString(),
          result.data['names'],
          result.data['provinceName'],
        ];
        prefs.setStringList(GlobalState.getInstance().logonDataKey, logon);
        await prefs.setBool(GlobalState.getInstance().logonKey, true);
        Navigator.pop(context); // <-- Corregido: cerrar el diálogo de carga
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePageView()));
      } else {
        Navigator.pop(context); // <-- Corregido: cerrar el diálogo de carga
        app.ackAlert(context, result.message, title: '');
      }
    } catch (e) {
      Navigator.pop(context); // <-- Corregido: cerrar el diálogo de carga
      app.ackAlert(context, "Error", title: '');
    }
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpView()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ApplicationLocalizations.of(context)!
                  .translate("dont_have_account") ?? "",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              ApplicationLocalizations.of(context)?.translate("btn_register") ?? "",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        wget.entryField(
            ApplicationLocalizations.of(context)?.translate("login_text_email") ?? "",
            emailController,
            TextInputType.emailAddress,
            context,
            Icon(Icons.mail_outline)),
        wget.entryField(
            ApplicationLocalizations.of(context)?.translate("login_text_password") ?? "",
            passwordController,
            TextInputType.text,
            context,
            Icon(Icons.lock),
            isPassword: true,
            passwordVisible: _passwordVisible, fnShowPassword: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(key: UniqueKey())),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  wget.appName(context),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  wget.submitButton(
                      context,
                      ApplicationLocalizations.of(context)
                              ?.translate("login_text_btn") ??
                          "",
                      fnLogin),
                  RecoveryPassword(),
                  wget.divider("or"),
                  InkWell(
                    onTap: () {
                      var dt = DateTime.now().millisecondsSinceEpoch;
                      signInAnonymous("$dt@coe.gob.do");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: blue_logo_coe,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            ApplicationLocalizations.of(context)?.translate("continue_without_register") ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                  ),
                  SizedBox(height: 10),
                  wget.gmailButton(
                    () => signInWithGoogle(),
                    ApplicationLocalizations.of(context)?.translate("continue_with_google") ?? ""
                  ),
                  SizedBox(height: height * .01),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
