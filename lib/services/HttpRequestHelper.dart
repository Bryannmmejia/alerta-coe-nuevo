import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:alertacoe/helper/globalState.dart';
import 'dart:io';
import '../helper/extensions.dart';

class HttpRequestHelper {
  static final HttpRequestHelper _instance = HttpRequestHelper._internal();

  factory HttpRequestHelper() {
    return _instance;
  }

  HttpRequestHelper._internal();

  Future<http.Response?> loginRequest(String endPoint, dynamic data, {required String token}) async {
    try {
      String url = GlobalState.getInstance().baseApi + endPoint;
      Uri ur = Uri.parse(url);
      String authToken = "Basic ${token.toBase64()}";
      var auth = {
        HttpHeaders.authorizationHeader: authToken,
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json"
      };
      return await http.post(ur, body: data, headers: auth);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<http.Response?> getRequest(
      String endPoint, Map<String, dynamic> queryParameters,
      {required String token}) async {
    try {
      String url = GlobalState.getInstance().baseApi + endPoint;
      String authToken = "Basic ${token.toBase64()}";
      var auth = {
        HttpHeaders.authorizationHeader: authToken,
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      var requestUrl = url + (queryString.isNotEmpty ? '?$queryString' : '');
      Uri ur = Uri.parse(requestUrl);
      return await http.get(ur, headers: auth);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<http.Response?> get(String url) async {
    try {
      Uri ur = Uri.parse(url);
      return await http.get(ur);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<http.Response?> postRequest(String endPoint, Map<String, dynamic> data, {required String token}) async {
    try {
      String url = GlobalState.getInstance().baseApi + endPoint;
      String authToken = "Basic ${token.toBase64()}";
      var auth = {
        HttpHeaders.authorizationHeader: authToken,
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json"
      };
      var request = jsonEncode({
        "post_data": jsonEncode(data),
        "request_from_user": {
          "username": GlobalState.getInstance().logonResult.username
        }
      });
      Uri ur = Uri.parse(url);
      return await http.post(ur, body: request, headers: auth);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<http.Response?> putRequest(String endPoint, Map<String, dynamic> data, {required String token}) async {
    try {
      String url = GlobalState.getInstance().baseApi + endPoint;
      String authToken = "Basic ${token.toBase64()}";
      var auth = {
        HttpHeaders.authorizationHeader: authToken,
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json"
      };
      var request = jsonEncode({
        "post_data": jsonEncode(data),
        "request_from_user": {
          "username": GlobalState.getInstance().logonResult.username
        }
      });
      Uri ur = Uri.parse(url);
      return await http.put(ur, body: request, headers: auth);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<http.Response?> deleteRequest(
      String endPoint, Map<String, dynamic> queryParameters,
      {required String token}) async {
    try {
      String url = GlobalState.getInstance().baseApi + endPoint;
      String authToken = "Basic ${token.toBase64()}";
      var auth = {
        HttpHeaders.authorizationHeader: authToken,
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json"
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      var requestUrl = url + (queryString.isNotEmpty ? '?$queryString' : '');
      Uri ur = Uri.parse(requestUrl);
      return await http.delete(ur, headers: auth);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
