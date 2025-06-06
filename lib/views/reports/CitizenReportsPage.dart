import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/location.dart';
import 'package:alertacoe/helper/myWidgets.dart';
import 'package:alertacoe/helper/textInputFormatter.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


//import 'package:path/path.dart';

class CitizenReportsPage extends StatefulWidget {
  @override
  _CitizenReportsPageState createState() => _CitizenReportsPageState();
}

class _CitizenReportsPageState extends State<CitizenReportsPage> {
  bool showPassword = false;
  var wget = MyWidgets();
  List<DropdownMenuItem> itemsEmergency = [];
  List<DropdownMenuItem> itemsProvince = [];
  List<DropdownMenuItem> itemsCounty = [];
  var _http = HttpRequestHelper();
  var app = ApplicationDefault();
  bool isBusy = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  var countySelected;
  var emergencySelected;
  var provinceSelected;
  File? _image; // <-- Cambiado a nullable

  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    this.init();
    this.fillReports();
  }

  init() async {
    try {
      var pos = await fetchLocation(context);
      if (pos != null) {
        latitude = pos.latitude;
        longitude = pos.longitude;
      }
      isBusy = true;
      var response = await _http.getRequest("apim/holder", {},
          token: GlobalState.getInstance().logonResult.token);
      var _result = HttpResponseModel.fromJson(json.decode(response!.body));
      for (var item in _result.data) {
        itemsProvince.add(DropdownMenuItem(
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
          this.isBusy = false;
          itemsProvince = itemsProvince;
        });
      }
    } catch (e) {
      isBusy = false;
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  _imgFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 600,
        maxHeight: 288,
      );
      if (image != null && this.mounted) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _imgFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 288,
        maxWidth: 600,
      );
      if (image != null && this.mounted) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  fillCounty(String id) async {
    try {
      isBusy = true;
      var response = await _http.getRequest(
          "apim/holder/county", {"provinceId": id},
          token: GlobalState.getInstance().logonResult.token);
      var _result = HttpResponseModel.fromJson(json.decode(response!.body));
      itemsCounty = [];
      for (var item in _result.data) {
        itemsCounty.add(DropdownMenuItem(
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
                  item["label"],
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
          this.isBusy = false;
          itemsCounty = itemsCounty;
        });
      }
    } catch (e) {
      isBusy = false;
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  fillReports() async {
    try {
      isBusy = true;
      var response = await _http.getRequest("apim/holder/emergency", {},
          token: GlobalState.getInstance().logonResult.token);
      var _result = HttpResponseModel.fromJson(json.decode(response!.body));
      itemsEmergency = [];
      for (var item in _result.data) {
        itemsEmergency.add(DropdownMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.check_box,
                size: 20,
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: Text(
                  item["label"],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          value: item["value"],
        ));
      }
      if (this.mounted) {
        setState(() {
          this.isBusy = false;
          itemsEmergency = itemsEmergency;
        });
      }
    } catch (e) {
      isBusy = false;
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  Future<Uint8List> readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File _file = File.fromUri(myUri);
    Uint8List bytes = Uint8List(0);
    try {
      bytes = await _file.readAsBytes();
      print('reading of bytes is completed');
    } catch (onError) {
      print('Exception Error while reading file from path:' + onError.toString());
    }
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 10, right: 16),
      child: isBusy
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
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.lightBlue,
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _image!,
                                  width: MediaQuery.of(context).size.width,
                                  height: 130,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width,
                                height: 130,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      "En esta sección usted puede reportar una situación de emergencia para ser atendida a la mayor brevedad posible.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  wget.myDropDown2(
                    context,
                    "Emergencia",
                    emergencySelected != "" ? emergencySelected : null,
                    itemsEmergency,
                    (dynamic val) {
                      setState(() {
                        emergencySelected = val;
                      });
                    },
                  ),
                  buildTextField(
                      "Titulo", "", false, TextInputType.text, titleController),
                  wget.myDropDown2(
                    context,
                    "Provincia",
                    provinceSelected != "" ? provinceSelected : null,
                    itemsProvince,
                    (dynamic val) {
                      this.fillCounty(val);
                      setState(() {
                        provinceSelected = val;
                      });
                    },
                  ),
                  wget.myDropDown2(
                    context,
                    "Municipio",
                    countySelected != "" ? countySelected : null,
                    itemsCounty,
                    (dynamic val) {
                      setState(() {
                        countySelected = val;
                      });
                    },
                  ),
                  buildTextField("Mensaje", "", false, TextInputType.text,
                      messageController,
                      maxLn: 3),
                  ButtonTheme(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    minWidth: MediaQuery.of(context).size.width,
                    height: 150.0,
                    buttonColor: Colors.blue[900],
                    highlightColor: Colors.blue[900],
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.transparent,
                                          width: 2.0)))),
                      onPressed: () async {
                        try {
                          if (emergencySelected == null) {
                            this.app.ackAlert(
                                context, "Favor, seleccionar una emergencia", title: '');
                            return;
                          }
                          if (titleController.text.isEmpty) {
                            this.app.ackAlert(
                                context, "Favor, proporcionar el titulo", title: '');
                            return;
                          }
                          if (provinceSelected == null) {
                            this.app.ackAlert(
                                context, "Favor, seleccionar una provincia", title: '');
                            return;
                          }
                          if (countySelected == null) {
                            this.app.ackAlert(
                                context, "Favor, seleccionar un municipio", title: '');
                            return;
                          }
                          if (messageController.text.isEmpty) {
                            this.app.ackAlert(
                                context, "Favor, escribir el mensaje", title: '');
                            return;
                          }
                          Uint8List? sFile;
                          if (_image != null) {
                            sFile = await readFileByte(_image!.path);
                          }
                          var obj = {
                            "message": messageController.text,
                            "title": titleController.text,
                            "province": provinceSelected,
                            "county": countySelected,
                            "emergency": emergencySelected,
                            "file": sFile,
                            "latitude": latitude,
                            "longitude": longitude,
                            "username":
                                GlobalState.getInstance().logonResult.username
                          };
                          var response = await _http.postRequest(
                              "apim/report", obj,
                              token:
                                  GlobalState.getInstance().logonResult.token);
                          var _result = HttpResponseModel.fromJson(
                              json.decode(response!.body));
                          print(_result.data);
                        } catch (e) {
                          app.ackAlert(context, e.toString(), title: '');
                        }
                      },
                      child: Text(
                        "Enviar",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    ),
                  ),
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
      {bool enable = true,
      int maxLn = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        controller: controller,
        maxLines: maxLn,
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
