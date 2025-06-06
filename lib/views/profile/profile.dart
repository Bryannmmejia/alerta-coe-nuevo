import 'dart:convert';

import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:flutter/material.dart';

import 'editProfile.dart';
import '../../helper/socketClient.dart';
import '../../helper/applicationDefault.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  var app = ApplicationDefault();
  var _http = HttpRequestHelper();
  dynamic _model;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      setState(() {
        isBusy = true;
      });
      SocketClient.getEmitter().on("onUpdateUserData", context,
          (dynamic ev, context) async {
        if (mounted) {
          setState(() {
            _model["names"] = ev.eventData["names"];
            _model["provinceName"] = ev.eventData["provinceName"];
            _model["phone"] = ev.eventData["phone"];
          });
        }

        var prefs = await app.getPreference();
        List<String> logon = [
          _model['username'],
          GlobalState.getInstance().logonResult.token,
          ev.eventData['province_id'].toString(),
          _model['names'],
          _model["provinceName"],
        ];
        prefs.setStringList(GlobalState.getInstance().logonDataKey, logon);
        GlobalState.getInstance().logonResult = LogonData(
          provinceId: ev.eventData['province_id'].toString(),
          fullName: _model['names'],
          token: GlobalState.getInstance().logonResult.token,
          username: _model['username'],
          userType: "app",
          provinceName: _model["provinceName"],
        );
      });
      var response = await _http.getRequest(
          "security/users/getone",
          {'username': GlobalState.getInstance().logonResult.username},
          token: GlobalState.getInstance().logonResult.token);
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        if (mounted) {
          setState(() {
            _model = result.data;
            isBusy = false;
          });
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: isBusy
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            : _model == null
                ? Center(child: Text("No hay datos de usuario"))
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ProfileHeader(
                          avatar: NetworkImage(
                              "${GlobalState.getInstance().baseUrlImage}user-profile-pic.png"),
                          coverImage: NetworkImage(
                              "${GlobalState.getInstance().baseUrlImage}logo-coe.png"),
                          title: _model["names"] ?? "",
                          subtitle: _model["username"] ?? "",
                          actions: <Widget>[
                            MaterialButton(
                              color: Colors.white,
                              shape: CircleBorder(),
                              elevation: 0,
                              child: Icon(Icons.edit),
                              onPressed: () {
                                app.navigateToWithWidget(
                                    context,
                                    "Editar Perfil",
                                    EditUserProfilePage(
                                      model: _model,
                                    ));
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        UserInfo(
                          model: _model,
                        ),
                      ],
                    ),
                  ));
  }
}

class UserInfo extends StatelessWidget {
  final dynamic model;

  const UserInfo({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "Información de Usuario",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            leading: Icon(Icons.my_location),
                            title: Text("Provincia"),
                            subtitle: Text(model["provinceName"] ?? ""),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Email"),
                            subtitle: Text(
                                GlobalState.getInstance().logonResult.username),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Telefono"),
                            subtitle: Text(model["phone"] ?? "No Provisto"),
                          ),
                          ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text("Fecha Reg."),
                            subtitle:
                                Text(model["dateFormat"] ?? ""),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<Object> coverImage;
  final ImageProvider<Object> avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader({
    Key? key,
    required this.coverImage,
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: actions,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5.0),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<Object> image;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar({
    Key? key,
    required this.image,
    this.borderColor = Colors.grey,
    this.backgroundColor,
    this.radius = 30,
    this.borderWidth = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image,
        ),
      ),
    );
  }
}
