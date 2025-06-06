import 'package:flutter/material.dart';
import './empty_widget.dart';

/// General utility widget used to render a cell divided into three rows
/// First row displays [label]
/// second row displays [iconData] if provided
/// third row displays [value]
class ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData? iconData; // <-- Cambiado a nullable

  const ValueTile(this.label, this.value, {this.iconData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 5),
        iconData != null
            ? Icon(
                iconData,
                color: Colors.white,
                size: 20,
              )
            : EmptyWidget(),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
