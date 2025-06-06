import 'dart:convert';

import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/location.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:flutter/material.dart';

import 'homeWeather.dart';

class WeatherPageView extends StatefulWidget {
  final String? province;

  const WeatherPageView({Key? key, this.province}) : super(key: key);

  @override
  _WeatherPageViewState createState() => _WeatherPageViewState();
}

class _WeatherPageViewState extends State<WeatherPageView> {
  final app = ApplicationDefault();
  final _http = HttpRequestHelper();
  dynamic _weather;

  @override
  void initState() {
    super.initState();
    if (widget.province != null) {
      init2();
    } else {
      init();
    }
  }

  Future<void> init() async {
    try {
      var pos = await fetchLocation(context);
      double latitude = 0;
      double longitude = 0;
      if (pos != null) {
        latitude = pos.latitude;
        longitude = pos.longitude;
      }
      String api =
          "https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude";
      var _resp = await _http.get(api);
      var obj = jsonDecode(_resp!.body);
      String? city = obj["address"]?["city"];
      var response = await _http.getRequest(
          "apim/weather",
          {
            "user": GlobalState.getInstance().logonResult.toJson().values,
            "coordinates": {
              "lat": latitude.toString(),
              "lng": longitude.toString()
            }.values,
            "cityName": city ?? GlobalState.getInstance().logonResult.provinceName
          },
          token: GlobalState.getInstance().logonResult.token);
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        if (mounted) {
          setState(() {
            _weather = result.data;
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  Future<void> init2() async {
    try {
      var response = await _http.getRequest(
          "apim/weather",
          {
            "user": GlobalState.getInstance().logonResult.toJson().values,
            "coordinates": {"lat": "0", "lng": "0"}.values,
            "cityName": widget.province
          },
          token: GlobalState.getInstance().logonResult.token);
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        if (mounted) {
          setState(() {
            _weather = result.data;
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WeatherWidget(
        weather: _weather,
      ),
    );
  }
}
