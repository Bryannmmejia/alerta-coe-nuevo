import 'package:flutter/material.dart';
import '../../application_localizations.dart';
import '../../helper/applicationDefault.dart';

class WeatherCardPage extends StatefulWidget {
  final double radius;
  final dynamic weatherData;

  const WeatherCardPage({Key? key, required this.radius, required this.weatherData}) : super(key: key);

  @override
  _WeatherCardPageState createState() => _WeatherCardPageState();
}

class _WeatherCardPageState extends State<WeatherCardPage> {
  var app = ApplicationDefault();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

  @override
  Widget build(BuildContext context) {
    return _buildTitledContainer(
      ApplicationLocalizations.of(context)?.translate("weather_card_header_text") ?? "",
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            widget.weatherData != null
                ? app.getWeatherIcon(widget.weatherData["currently"]["icon"])
                : Icons.cloud_outlined,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(width: 30),
          Flexible(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.weatherData != null
                        ? (widget.weatherData["cityName"] ?? "")
                        : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.weatherData != null
                        ? (widget.weatherData["weatherDate"] ?? "")
                        : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 30),
          Flexible(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.weatherData != null
                        ? ((widget.weatherData["currently"]["temperature"] ?? 0).round().toString() + '°C')
                        : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.weatherData != null
                        ? (widget.weatherData["weatherCondition"] ?? "")
                        : "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      radius: widget.radius,
    );
  }

  Container _buildTitledContainer(String title,
      {Widget? child, double? height, double radius = 20.0}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
            colors: [
              Colors.blue[900]!,
              Colors.lightBlue,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                color: Colors.white),
          ),
          if (child != null) ...[const SizedBox(height: 10.0), child]
        ],
      ),
    );
  }
}
