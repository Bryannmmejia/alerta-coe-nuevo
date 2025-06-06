import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ExtensibleString on String {
  String toBase64() {
    var str = utf8.encode(this);
    return base64.encode(str);
  }
}

extension ExtensibleDouble on double {
  double celsiusToFarhenheit() => this * 1.8 + 32;
  double farhenheitToCelsius() => (this - 32) / 1.8;
  String formatMoney() {
    final oCcy = new NumberFormat("#,##0.00", "en_US");
    return oCcy.format(this);
  }
}

extension ExtensibleInteger on int {
  String formatMoney() {
    final oCcy = new NumberFormat("#,##0.00", "en_US");
    return oCcy.format(this);
  }
}

extension ExtensibleArray on List {}

extension ExtensibleColor on Colors {
  Color? gisRed() {
    return Colors.redAccent[700];
  }

  Color gisYellow() {
    return Colors.yellowAccent;
  }

  Color? gisGreen() {
    return Colors.greenAccent[700];
  }
}
