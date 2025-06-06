import 'dart:convert';

import 'package:alertacoe/helper/location.dart';
import 'package:alertacoe/assets/network_image.dart';
import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/views/weather/weatherCard.dart';
import 'package:flutter/material.dart';
import 'homeWeather.dart';

class WeatherPageMaster extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPageMaster> {
  final app = ApplicationDefault();
  final _http = HttpRequestHelper();
  dynamic _weather;
  bool loading = true;

  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> loadLinks() async {
    try {
      var response = await _http.getRequest(
        "apim/links",
        {"user": GlobalState.getInstance().logonResult.toJson().values},
        token: GlobalState.getInstance().logonResult.token,
      );
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        List<Activity> tempActivities = [];
        for (var item in result.data) {
          tempActivities.add(
            Activity(
              title: item["title"] ?? "",
              icon: Icons.cloud_outlined,
              url: item["url"] ?? "",
            ),
          );
        }
        if (mounted) {
          setState(() {
            activities = tempActivities;
            loading = false;
          });
        }
      } else {
        if (mounted) setState(() => loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
      debugPrint(e.toString());
      app.ackAlert(context, e.toString(), title: '');
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
      String? city = obj["address"]["city"];

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
        token: GlobalState.getInstance().logonResult.token,
      );
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        if (mounted) {
          setState(() {
            _weather = result.data;
            loading = false;
          });
        }
      } else {
        if (mounted) setState(() => loading = false);
      }
      await loadLinks();
    } catch (e) {
      if (mounted) setState(() => loading = false);
      debugPrint(e.toString());
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: null,
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            )
          : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildStats(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              child: WeatherCardPage(
                radius: 20.0,
                weatherData: _weather,
              ),
              onTap: () {
                app.navigateToWithWidget(
                  context,
                  "Estado del Tiempo",
                  WeatherWidget(
                    weather: _weather,
                  ),
                );
              },
            ),
          ),
        ),
        _buildActivities(context),
      ],
    );
  }

  SliverPadding _buildStats(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid.count(
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5,
        crossAxisCount: 3,
        children: <Widget>[
          InkWell(
            onTap: () {
              app.navigateToWebView(
                  context,
                  'https://www.windy.com/18.480/-69.940?18.539,-69.969,10',
                  "windy");
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "windy",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: PNetworkImage(
                        "https://api.windy.com/static/img/logo-full.png",
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width / 17,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              app.navigateToWebView(
                  context,
                  'http://onamet.gob.do/index.php/pronosticos/informe-del-tiempo',
                  "http://onamet.gob.do");
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "onamet",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: PNetworkImage(
                        "https://centroclima.org/wp-content/uploads/2016/02/onamet-logo-e1467676042895.png",
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width / 18,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              app.navigateToWebView(
                  context, 'http://climared.com/tiempo/', "CLIMARED");
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "climared",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: PNetworkImage(
                        "http://climared.com/wp-content/uploads/2016/06/brand.png",
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width / 15,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildActivities(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: _buildTitledContainer(
          "Otros Enlaces",
          height: MediaQuery.of(context).size.height / 2.5,
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: activities
                .map(
                  (activity) => Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          app.navigateToWebView(
                              context, activity.url, activity.title);
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              child: Icon(
                                activity.icon,
                                size: 18.0,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              activity.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Container _buildTitledContainer(String title, {Widget? child, double? height}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
          ),
          if (child != null) ...[const SizedBox(height: 10.0), child]
        ],
      ),
    );
  }
}

class Activity {
  final String title;
  final IconData icon;
  final String url;

  Activity({required this.title, required this.icon, required this.url});
}
