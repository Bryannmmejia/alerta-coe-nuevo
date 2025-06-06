import 'dart:convert';

import 'package:alertacoe/models/ResponseCallModel.dart';
import 'package:flutter/material.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import '../services/HttpRequestHelper.dart';

class ProfileViewModel extends ChangeNotifier {
  var http = HttpRequestHelper();
  String html = "";

  Future<ResponseCallModel<String>> getProfile(
      String token, Map<String, dynamic> params) async {
    try {
      var response =
          await http.getRequest("betMobile/profile", params, token: token);
      var result =
          HttpResponseModel<String>.fromJson(json.decode(response!.body));
      if (result.hasError && result.httpStatus != 200) {
        return ResponseCallModel<String>(true, result.message);
      } else {
        html = result.data;
        notifyListeners();
        return ResponseCallModel(false, "");
      }
    } catch (e) {
      html = "";
      return ResponseCallModel(true, html);
    }
  }
}
