import 'package:flutter/material.dart';

class GlobalState {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final GlobalState _singleton = GlobalState._internal();

  GlobalState._internal();

  //This is what's used to retrieve the instance through the app
  static GlobalState getInstance() => _singleton;

  late BuildContext appBuildContext;
  String logonKey = "coe_logged_in";
  String logonDataKey = "coe_logon_data";
  late LogonData logonResult;

  bool isOnline = false;
  final String appName = "AlertaCOE";
  final String appVersion = "Versión 3.0";
  int messageCount = 0;
  int notificationsCount = 0;
  bool isEvent = false;

  // final String baseApi = "http://191.97.89.36:3001/";
  // final String chatUrl = "http://191.97.89.36:9988/";
  final String baseUrlImage = "http://191.97.89.36:8090/";

  final String baseApi = "http://10.0.0.9:3001/";
  final String chatUrl = "http://10.0.0.9:9988/";

}

class LogonData {
  String username;
  String fullName;
  String provinceId;
  String token;
  String userType;
  String provinceName;

  LogonData({
    required this.provinceId,
    required this.fullName,
    required this.token,
    required this.username,
    required this.userType,
    required this.provinceName,
  });

  Map<String, dynamic> toJson() {
    return {
      "token": this.token,
      "userType": this.userType,
      "username": this.username,
      "fullName": this.fullName,
      "provinceId": this.provinceId,
      "provinceName": this.provinceName
    };
  }
}
