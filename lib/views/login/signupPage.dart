import 'dart:convert';
import 'dart:io';
import 'package:alertacoe/helper/constants.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/views/login/LoginPage.dart';

import '../../helper/applicationDefault.dart';
import 'package:alertacoe/helper/myWidgets.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/views/widget/bezierContainer.dart';
import 'package:flutter/material.dart';
import '../../application_localizations.dart';
import '../HomePage.dart';

var wget = new MyWidgets();
var app = ApplicationDefault();

class SignUpView extends StatefulWidget {
  const SignUpView({super.key, this.title});
  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpView> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  late String provinceSelected;
  List<DropdownMenuItem> items = [];
  bool _passwordVisible = false;
  var _http = HttpRequestHelper();
  bool isBusy = true;

  @override
  void initState() {
    super.initState();
    this.init();
  }

  init() async {
    try {
      var response = await _http.getRequest("apim/holder/province", {},
          token: "C-79851-ltjoiai-Cx33@@-86667227");
      var _result = HttpResponseModel.fromJson(json.decode(response!.body));
      for (var item in _result.data) {
        items.add(DropdownMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.gps_fixed_outlined,
                size: 20,
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: Text(
                  item["name"],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          value: item["id"],
        ));
      }
      if (this.mounted) {
        setState(() {
          items = items;
        });
      }
      this.isBusy = false;
    } catch (e) {
      this.isBusy = false;
      debugPrint(e.toString());
    }
  }

  void fnRegister() async {
    try {
      if (fullNameController.text.isEmpty) {
        final localizations = ApplicationLocalizations.of(context);
        app.ackAlert(
            this.context,
            localizations?.translate("login_text_provide_fullName") ?? "Please provide your full name.", title: '');
        return;
      }
      String email = emailController.text;
      if (email.isEmpty) {
        app.ackAlert(
            this.context,
            ApplicationLocalizations.of(context)
                ?.translate("login_text_provide_email") ?? "Please provide your email.", title: '');
        return;
      }
      if (!app.regEmail.hasMatch(email)) {
        app.ackAlert(
            this.context,
            ApplicationLocalizations.of(context)
                ?.translate("login_text_provide_valid_email") ?? "Please provide a valid email.", title: '');
        return;
      }
      if (provinceSelected.isEmpty) {
        app.ackAlert(
            this.context,
            ApplicationLocalizations.of(context)
                ?.translate("login_text_provide_province") ?? "Please provide your province.", title: '');
        return;
      }
      if (passwordController.text.isEmpty) {
        app.ackAlert(
            this.context,
            ApplicationLocalizations.of(context)
                ?.translate("login_text_provide_password") ?? "Please provide your password.", title: '');
        return;
      }
      wget.onLoading(
          context,
          ApplicationLocalizations.of(context)?.translate("wait_text") ?? "Please wait...");
      Row _row = items
          .firstWhere((element) => element.value == provinceSelected)
          .child as Row;
      Flexible _fl = _row.children[2] as Flexible;
      Text txt = _fl.child as Text;
      Map<String, dynamic> obj = {
        'province_id': provinceSelected,
        'provinceName': txt.data,
        'username': email,
        'names': fullNameController.text.toUpperCase(),
        'phone': phoneController.text,
        'password': passwordController.text,
        'lang': ApplicationLocalizations.of(context)?.appLocale,
        'platform': Platform.operatingSystem
      };
      var response = await _http.postRequest("security/users", obj,
          token: "C-79851-ltjoiai-Cx33@@-86667227");
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      //print(result.data);
      if (result.httpStatus == 200) {
        GlobalState.getInstance().logonResult = new LogonData(
          provinceId: result.data['province'].toString(),
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
          result.data['lang']
        ];
        prefs.setStringList(GlobalState.getInstance().logonDataKey, logon);
        await prefs.setBool(GlobalState.getInstance().logonKey, true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePageView()));
      } else {
        Navigator.pop(this.context);
        app.ackAlert(this.context, result.message, title: '');
      }
    } catch (e) {
      print(e);
      Navigator.pop(this.context);
      app.ackAlert(this.context, e.toString(), title: '');
    }
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage(title: 'page',)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0),
        padding: EdgeInsets.all(0),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ApplicationLocalizations.of(context)
                  ?.translate('ready_account_text') ?? 'Already have an account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              ApplicationLocalizations.of(context)?.translate('login_text_btn') ?? 'Login',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return new Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        wget.myDropDown(
          context,
          ApplicationLocalizations.of(context)?.translate("login_text_province") ?? "Select Province",
          provinceSelected != ""
              ? provinceSelected
              : (ApplicationLocalizations.of(context)
                      ?.translate("login_text_province") ??
                  "Select Province"),
          items,
          (dynamic val) {
            setState(() {
              provinceSelected = val;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        wget.entryField(
            ApplicationLocalizations.of(context)
                    ?.translate('login_name_lastname') ??
                'Full Name',
            fullNameController,
            TextInputType.text,
            context,
            Icon(Icons.person)),
        SizedBox(
          height: 5,
        ),
        wget.entryField(
            ApplicationLocalizations.of(context)?.translate('login_text_phone') ?? 'Phone',
            phoneController,
            TextInputType.phone,
            context,
            Icon(Icons.phone)),
        SizedBox(
          height: 5,
        ),
        wget.entryField(
            ApplicationLocalizations.of(context)?.translate('login_text_email') ?? 'Email',
            emailController,
            TextInputType.emailAddress,
            context,
            Icon(Icons.mail_outline)),
        SizedBox(
          height: 5,
        ),
        wget.entryField(
            ApplicationLocalizations.of(context)?.translate('login_text_password') ?? 'Password',
            passwordController,
            TextInputType.text,
            context,
            Icon(Icons.lock),
            isPassword: true,
            passwordVisible: _passwordVisible, fnShowPassword: () {
          if (mounted) {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          }
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext c) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(key: UniqueKey()),
            ),
            this.isBusy
                ? Center(
                    child: Visibility(
                      maintainSize: false,
                      maintainAnimation: false,
                      maintainState: false,
                      visible: isBusy,
                      child: Container(
                        margin: EdgeInsets.only(top: 50, bottom: 30),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .2),
                          wget.appName(context),
                          SizedBox(
                            height: 5,
                          ),
                          _emailPasswordWidget(),
                          SizedBox(
                            height: 5,
                          ),
                          wget.submitButton(
                              context,
                              ApplicationLocalizations.of(context)
                                      ?.translate('btn_register') ?? 'Register',
                              fnRegister),
                          SizedBox(height: height * .03),
                          _loginAccountLabel(),
                        ],
                      ),
                    ),
                  ),
            Positioned(
                top: 40,
                left: 0,
                child: wget.backButton(
                    context,
                    ApplicationLocalizations.of(context)?.translate('btn_back') ?? 'Back')),
          ],
        ),
      ),
    );
  }
}
