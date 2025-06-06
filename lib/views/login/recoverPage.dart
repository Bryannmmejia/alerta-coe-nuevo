import 'dart:convert';

import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:flutter/material.dart';
import '../../application_localizations.dart';
import '../../helper/myWidgets.dart';

var wget = new MyWidgets();
var app = ApplicationDefault();
var _http = HttpRequestHelper();

class RecoveryPassword extends StatefulWidget {
  @override
  _RecoveryPassword createState() => _RecoveryPassword();
}

class _RecoveryPassword extends State<RecoveryPassword> {
  TextEditingController emailController = new TextEditingController();

  void fnRecover() async {
    try {
      String email = emailController.text;
      if (email.isEmpty) {
        app.ackAlert(
            this.context,
            ApplicationLocalizations.of(context)!
                .translate("login_text_provide_email") ?? "Please provide your email", title: '');
        return;
      }

      if (!app.regEmail.hasMatch(email)) {
        app.ackAlert(
            this.context,
            ApplicationLocalizations.of(context)?.translate("login_text_provide_valid_email") ?? "Please provide a valid email", title: '');
        return;
      }
      Map<String, dynamic> obj = {
        'email': email,
        'lang': ApplicationLocalizations.of(context)!.appLocale
      };
      var response = await _http.postRequest("security/recoverpassword", obj,
          token: "C-79851-ltjoiai-Cx33@@-86667227");
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        Navigator.pop(context);
        app.ackAlert(this.context, result.message, title: '');
        emailController.text = "";
      } else {
        app.ackAlert(this.context, result.message, title: '');
      }
    } catch (e) {
      app.ackAlert(this.context, e.toString(), title: '');
    }
  }

  Widget _forgotPassword() {
    return InkWell(
      onTap: () => {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(100.0)),
          ),
          builder: (BuildContext bc) {
            return new Container(
              height: MediaQuery.of(context).size.height, // * 0.4,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      wget.divider(
                        ApplicationLocalizations.of(context)
                                ?.translate("recover_password_header_text") ??
                            "Recover Password"),
                      SizedBox(height: 20),
                      wget.entryField(
                          ApplicationLocalizations.of(context)
                                  ?.translate("login_text_email") ?? "Email",
                          emailController,
                          TextInputType.emailAddress,
                          context,
                          Icon(Icons.mail_outline)),
                      SizedBox(height: 20),
                      wget.submitButton(
                          context,
                          ApplicationLocalizations.of(context)
                                  ?.translate("btn_recover_text") ?? "Recover",
                          fnRecover),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerRight,
        child: Text(
            ApplicationLocalizations.of(context)
                    ?.translate("forgot_password_text") ?? "Forgot Password",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _forgotPassword();
  }
}
