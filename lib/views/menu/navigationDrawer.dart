import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/oval-right-clip.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final Color primary = Colors.white;
final Color active = Colors.grey.shade800;
final Color divider = Colors.grey.shade600;
var app = ApplicationDefault();
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> logOut(BuildContext context) async {
  await _googleSignIn.signOut();
  var prefs = await app.getPreference();
  await prefs.setBool(GlobalState.getInstance().logonKey, false);
  Navigator.of(context).pushReplacementNamed('/');
}

Widget menuOptions(List<Widget> options, BuildContext buildContext) {
  return ClipPath(
    clipper: OvalRightBorderClipper(),
    child: Drawer(
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 40),
        decoration: BoxDecoration(
            color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
        width: 300,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                      color: active,
                    ),
                    onPressed: () {
                      logOut(buildContext);
                    },
                  ),
                ),
                Container(
                  height: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange])),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        GlobalState.getInstance().baseUrlImage +
                            "user-profile-pic.png"),
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  GlobalState.getInstance().logonResult.fullName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Text(
                  GlobalState.getInstance().logonResult.username,
                  style: TextStyle(color: active, fontSize: 16.0),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                for (var x in options) x
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
