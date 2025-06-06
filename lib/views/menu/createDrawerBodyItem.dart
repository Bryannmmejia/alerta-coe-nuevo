import 'package:flutter/material.dart';

Widget createDrawerBodyItem(
    {required IconData icon, required String text, required bool selected, required GestureTapCallback onTap}) {
  return ListTile(
    selected: selected,
    selectedTileColor: Colors.yellow[700],
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
