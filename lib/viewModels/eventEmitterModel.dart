import 'package:flutter/material.dart';


class EventEmitterModel extends ChangeNotifier {
  static final EventEmitterModel _instance = EventEmitterModel._internal();

  factory EventEmitterModel() {
    return _instance;
  }


  EventEmitterModel._internal();


}
