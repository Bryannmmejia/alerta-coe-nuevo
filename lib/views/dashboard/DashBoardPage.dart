import 'dart:convert';

import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/location.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/views/weather/homeWeather.dart';
import 'package:alertacoe/views/weather/weatherCard.dart';
import 'package:alertacoe/views/webview/index.dart';
import 'package:flutter/material.dart';
import '../../application_localizations.dart';
import '../../helper/globalState.dart';

class DashboardPage extends StatefulWidget {
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextStyle whiteText = TextStyle(color: Colors.white);
  String _url = "";
  final app = ApplicationDefault();
  final _http = HttpRequestHelper();
  dynamic _weather;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    this.init();
  }

  init() async {
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
      String city = obj["address"]["city"];
      var response = await _http.getRequest(
          "apim/weather",
          {
            "user": GlobalState.getInstance().logonResult.toJson().values,
            "coordinates": {
              "lat": latitude.toString(),
              "lng": longitude.toString()
            }.values,
            "cityName": city,
            "lang": ""
          },
          token: GlobalState.getInstance().logonResult.token);
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        if (this.mounted) {
          setState(() {
            this._url = "http://coe.gob.do/index.php/noticias";
            _weather = result.data;
            loading = false;
          });
        }
      } else {
        loading = false;
      }
    } catch (e) {
      loading = false;
      debugPrint(e as String?);
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).buttonColor,
                ),
              )
            : _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          //const SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
              child: WeatherCardPage(
                radius: 20.0,
                weatherData: this._weather,
              ),
              onTap: () => {
                app.navigateToWithWidget(
                  context,
                  ApplicationLocalizations.of(context)
                          ?.translate("menu_option_3") ?? "menu_option_3",
                  WeatherWidget(
                    weather: this._weather,
                  ),
                )
              },
            ),
          ),
          Divider(
            height: 2,
          ),
          Container(
            color: Colors.white24,
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 2.2,
            child: WebViewPage(url: _url),
          ),
          const SizedBox(height: 0.0),
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 32.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          color: Colors.blue[700],
        ),
        child: InkWell(
          onTap: () {
            SocketClient.getEmitter()
                .emit("onNavigationListener", this, {"index": 1});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  "CENTRO OPERACIONES DE EMERGENCIAS (COE)",
                  style: whiteText.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                trailing: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                      GlobalState.getInstance().baseUrlImage +
                          "user-profile-pic.png"),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  GlobalState.getInstance().logonResult.fullName,
                  style: whiteText.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  GlobalState.getInstance().logonResult.provinceName,
                  style: whiteText,
                ),
              ),
            ],
          ),
        ));
  }
}

extension on ThemeData {
  get buttonColor => null;
}
