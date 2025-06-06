import 'package:alertacoe/views/widget/bezierContainer.dart';
import 'package:flutter/material.dart';
import '../../helper/globalState.dart';

Widget createDrawerHeader() {
  return DrawerHeader(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: Stack(children: <Widget>[
        Positioned(top: -400 * .10, right: -200 * .3, child: BezierContainer(key: UniqueKey())),
        Positioned(
            bottom: 0.0,
            left: 60.0,
            child: Text(GlobalState.getInstance().appName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold))),
      ]));
}
