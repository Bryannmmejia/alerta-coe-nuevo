import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../application_localizations.dart';
import 'value_tile.dart';

class WeatherWidget extends StatefulWidget {
  final dynamic weather;

  WeatherWidget({@required this.weather});

  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final app = ApplicationDefault();
  late Locale appLocale;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    appLocale = Localizations.localeOf(context);
    if (widget.weather == null)
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    int currentTemp = widget.weather["currently"]["temperature"].round();
    int maxTemp = widget.weather["daily"]["data"][0]["temperatureMax"].round();
    int minTemp = widget.weather["daily"]["data"][0]["temperatureMin"].round();

    return Container(
      constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
            colors: [
              weather_background,
              kPrimaryColor,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.weather["cityName"].toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 5,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.weather["weatherCondition"].toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 5,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  app.getWeatherIcon(widget.weather["currently"]["icon"]),
                  color: Colors.white,
                  size: 70,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '$currentTemp°C',
                  style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.w100,
                      color: Colors.white),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ValueTile("max", '$maxTemp°'),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Center(
                            child: Container(
                          width: 1,
                          height: 30,
                          color: Colors.white,
                        )),
                      ),
                      ValueTile("min", '$minTemp°'),
                    ]),
              ],
            ),
            Padding(
              child: Divider(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
            ),
            Container(
              height: 75,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.weather["hourly"]["data"].length,
                separatorBuilder: (context, index) => Divider(
                  height: 100,
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(left: 10, right: 10),
                itemBuilder: (context, index) {
                  final item = widget.weather["hourly"]["data"][index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                        child: ValueTile(
                      DateFormat(
                              'E, ha',
                              Locale(appLocale.languageCode,
                                      appLocale.countryCode)
                                  .toString())
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              item["time"] * 1000)),
                      '${item["temperature"].round()}°',
                      iconData: app.getWeatherIcon(item["icon"]),
                    )),
                  );
                },
              ),
            ),
            Padding(
              child: Divider(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ValueTile(
                  ApplicationLocalizations.of(context)
                          ?.translate("weather_option_details_1") ??
                      '',
                  '${widget.weather["currently"]["windSpeed"]} m/s',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Container(
                      width: 1,
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                ValueTile(
                  ApplicationLocalizations.of(context)
                          ?.translate("weather_option_details_2") ??
                      '',
                  DateFormat('h:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        widget.weather["daily"]["data"][0]["sunriseTime"] *
                            1000),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Container(
                      width: 1,
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                ValueTile(
                  ApplicationLocalizations.of(context)
                          ?.translate("weather_option_details_3") ??
                      '',
                  DateFormat('h:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        widget.weather["daily"]["data"][0]["sunsetTime"] *
                            1000),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Container(
                      width: 1,
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                ValueTile(
                  ApplicationLocalizations.of(context)
                          ?.translate("weather_option_details_4") ??
                      '',
                  '${widget.weather["currently"]["humidity"]}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
