import 'dart:convert';

import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/myWidgets.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:alertacoe/helper/textInputFormatter.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:flutter/material.dart';

import '../../application_localizations.dart';

var wget = MyWidgets();

class EditUserProfilePage extends StatefulWidget {
  final dynamic model;

  const EditUserProfilePage({Key? key, required this.model}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditUserProfilePage> {
  bool showPassword = false;
  List<DropdownMenuItem> items = [];
  var _http = HttpRequestHelper();
  String? provinceSelected;
  var app = ApplicationDefault();
  bool isBusy = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    try {
      setState(() {
        isBusy = true;
      });
      var response = await _http.getRequest("apim/holder", {},
          token: GlobalState.getInstance().logonResult.token);
      var _result = HttpResponseModel.fromJson(json.decode(response!.body));
      nameController.text = widget.model["names"] ?? "";
      passwordController.text = widget.model["password"] ?? "";
      emailController.text = widget.model["username"] ?? "";
      phoneController.text = widget.model["phone"] ?? "";
      items = [];
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
                  item["name"] ?? "",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          value: item["id"],
        ));
      }
      if (mounted) {
        setState(() {
          provinceSelected = widget.model["province_id"];
          isBusy = false;
        });
      }
    } catch (e) {
      setState(() {
        isBusy = false;
      });
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          )
        : Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "${GlobalState.getInstance().baseUrlImage}user-profile-pic.png",
                                  ))),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  buildTextField("Nombre", widget.model["names"] ?? "", false,
                      TextInputType.text, nameController),
                  buildTextField("E-mail", widget.model["username"] ?? "", false,
                      TextInputType.emailAddress, emailController,
                      enable: false),
                  buildTextField("Password", widget.model["password"] ?? "", true,
                      TextInputType.text, passwordController),
                  wget.myDropDown2(
                    context,
                    ApplicationLocalizations.of(context)
                            ?.translate("login_text_province") ??
                        "Provincia",
                    provinceSelected != null && provinceSelected != ""
                        ? provinceSelected!
                        : "",
                    items,
                    (dynamic val) {
                      setState(() {
                        provinceSelected = val;
                      });
                    },
                  ),
                  buildTextField("Telefono", widget.model["phone"] ?? "", false,
                      TextInputType.phone, phoneController),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("CANCELAR",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            Row _row = items
                                .where((element) =>
                                    element.value == provinceSelected)
                                .first
                                .child as Row;
                            Flexible f = _row.children[2] as Flexible;
                            Text t = f.child as Text;
                            var obj = {
                              "names": nameController.text,
                              "password": passwordController.text,
                              "phone": phoneController.text,
                              "username": emailController.text,
                              "provinceName": t.data,
                              "province_id": provinceSelected,
                              "id": widget.model["id"],
                              "_id": widget.model["_id"]
                            };
                            var response = await _http.putRequest(
                                "security/users", obj,
                                token: GlobalState.getInstance()
                                    .logonResult
                                    .token);
                            var result = HttpResponseModel.fromJson(
                                json.decode(response!.body));
                            if (result.httpStatus == 200) {
                              SocketClient.getEmitter()
                                  .emit("onUpdateUserData", this, obj);
                              Navigator.of(context).pop();
                              setState(() {
                                isBusy = false;
                              });
                            } else {
                              setState(() {
                                isBusy = false;
                              });
                              app.ackAlert(context, result.message, title: '');
                            }
                          } catch (e) {
                            setState(() {
                              isBusy = false;
                            });
                            app.ackAlert(context, e.toString(), title: '');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          "Guardar",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Widget buildTextField(
      String labelText,
      String placeholder,
      bool isPasswordTextField,
      TextInputType kBoardType,
      TextEditingController controller,
      {bool enable = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        controller: controller,
        keyboardType: kBoardType,
        inputFormatters: [UpperCaseTextFormatter()],
        enabled: enable,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
