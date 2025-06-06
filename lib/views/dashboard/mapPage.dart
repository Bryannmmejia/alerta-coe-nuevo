import 'dart:convert';

import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/popover.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:alertacoe/models/AlertModel.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/views/recomendations/recomendationCoastView.dart';
import 'package:alertacoe/views/recomendations/recomendationView.dart';
import 'package:alertacoe/views/weather/WeatherPageView.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import '../../helper/PathPainter.dart';
import '../../assets/network_image.dart';
import '../../helper/applicationDefault.dart';
import '../../helper/constants.dart';

class MapPageView extends StatefulWidget {
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPageView> {
  final notifier = ValueNotifier(Offset.zero);
  var _http = HttpRequestHelper();
  var app = ApplicationDefault();
  String provinceSelected = "";
  final AlertModel _model = AlertModel();
  bool isBusy = true;

  @override
  void initState() {
    super.initState();
    SocketClient.subscribe("onProvinceDetails", (dynamic p) {
      try {
        if (mounted) {
          setState(() {
            _model.impactReport = p["data"];
          });
        }
        showModalBottomSheet(
          context: context,
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          builder: (BuildContext bc) {
            return Popover(
              key: Key("popover"),
              child: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Resumen de Impacto: ${p["provinceName"]}",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(height: 1),
                      SizedBox(height: 10),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _model.impactReport.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                child: Text(
                                  _model.impactReport[index]["label"],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                width: MediaQuery.of(context).size.width / 1.5,
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Text(
                                  _model.impactReport[index]["data"],
                                  style: TextStyle(fontSize: 14),
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: 5, endIndent: 1);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } catch (e) {
        app.ackAlert(context, e.toString(), title: 'Error');
      }
    });
    init();
  }

  Future<void> init() async {
    try {
      var response = await _http.getRequest(
        "apim/events",
        {"user": GlobalState.getInstance().logonResult.toJson().values},
        token: GlobalState.getInstance().logonResult.token,
      );
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        if (mounted) {
          setState(() {
            _model.event.name = result.data["event"]["name"];
            _model.message = result.data["message"];
            _model.projectText = result.data["projectText"];
            _model.provincesInAlerts = result.data["provincesInAlerts"];
            _model.recommendations = result.data["recommendations"];
            _model.coasts = result.data["coasts"];
            _model.impactReport = result.data["impactReport"];
            _model.alertDateFormatted = result.data["alertDateFormatted"];
          });
        }
        _model.update();
        setState(() {
          isBusy = false;
        });
      } else {
        setState(() {
          isBusy = false;
        });
      }
    } catch (e) {
      setState(() {
        isBusy = false;
      });
      debugPrint(e.toString());
    }
  }

  void showProvinceDetails(String province) {
    try {
      SocketClient.emit("onProvinceDetails", arguments: {
        "username": GlobalState.getInstance().logonResult.username,
        "province": province
      });
    } catch (e) {
      app.ackAlert(context, e.toString(), title: 'Error');
    }
  }

  void showAlertDetails(String text) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          key: Key("popoverAlertDetails"),
          child: Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    text,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? Center(
            child: Visibility(
              maintainSize: false,
              maintainAnimation: false,
              maintainState: false,
              visible: isBusy,
              child: Container(
                margin: EdgeInsets.only(top: 50, bottom: 30),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              backgroundColor: secondaryColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  height: 40,
                  color: secondaryColor,
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: <Widget>[
                        Expanded(child: Container()),
                        TabBar(
                          isScrollable: true,
                          labelColor: kPrimaryColor,
                          indicatorColor: kPrimaryColor,
                          unselectedLabelColor: lightBlueColor,
                          onTap: (int index) {
                            _model.canDrawProvince = index == 0;
                          },
                          tabs: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Provincias",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Costas",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  // Provincias tab
                  Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTapDown: (details) {},
                            behavior: HitTestBehavior.opaque,
                            child: InteractiveViewer(
                              panEnabled: true,
                              onInteractionStart: (details) {},
                              onInteractionEnd: (details) {},
                              minScale: 0.5,
                              maxScale: 4,
                              child: Transform.scale(
                                scale: .85,
                                child: Listener(
                                  onPointerUp: (e) =>
                                      notifier.value = e.localPosition,
                                  child: CustomPaint(
                                    painter: MapPainter(
                                      notifier,
                                      (String text) async {
                                        if (provinceSelected != text) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (mounted) {
                                              showProvinceDetails(text);
                                            }
                                          });
                                          provinceSelected = text;
                                        }
                                      },
                                      _model,
                                    ),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2.5,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Text(
                                _model.event.name,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            left: 35,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: Text(
                                _model.alertDateFormatted,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: MediaQuery.of(context).size.width / 2.5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Image.asset(
                                'assets/images/logo-coe-96x96.png',
                                height: 60.0,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 2.9,
                            left: 5,
                            child: InkWell(
                              onTap: () {
                                showProvinceDetails("General");
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.22,
                                height: 100,
                                color: Colors.transparent,
                                padding: EdgeInsets.all(0.0),
                                child: Table(
                                  border: TableBorder.all(
                                      color: Colors.transparent),
                                  children: [
                                    TableRow(children: [
                                      Container(
                                        child: Text(
                                          'V/Afectadas',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'V/Destruidas',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'Desplazados',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]),
                                    TableRow(
                                      children: [
                                        Text(
                                          '0',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text('0', textAlign: TextAlign.center),
                                        Text('0', textAlign: TextAlign.center),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 3,
                            left: MediaQuery.of(context).size.width - 60,
                            child: InkWell(
                              onTap: () {
                                SocialShare.shareOptions(_model.message)
                                    .then((data) {
                                  print(data);
                                });
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Icon(
                                  Icons.share,
                                  size: 25,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1),
                      InkWell(
                        onTap: () {
                          showAlertDetails(_model.message);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          color: secondaryColor,
                          height: MediaQuery.of(context).size.height / 3.1,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  _model.message,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: blackColor),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1),
                      InkWell(
                        onTap: () {
                          app.navigateToWithWidget(context, _model.event.name,
                              RecommendationViewPage(_model.recommendations));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(0.0),
                          height: 40,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_up_outlined,
                                size: 30,
                                color: whiteColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Ver Recomendaciones",
                                style: TextStyle(fontSize: 20, color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Costas tab
                  Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: InteractiveViewer(
                              panEnabled: true,
                              onInteractionStart: (details) {},
                              onInteractionEnd: (details) {},
                              minScale: 0.5,
                              maxScale: 4,
                              child: Transform.scale(
                                scale: .85,
                                child: Listener(
                                  onPointerUp: (e) =>
                                      notifier.value = e.localPosition,
                                  child: CustomPaint(
                                    painter: MapPainter(
                                      notifier,
                                      (String text) {
                                        if (provinceSelected != text) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (mounted) {
                                              app.navigateToWithWidget(
                                                  context,
                                                  "Estado del Tiempo",
                                                  WeatherPageView(
                                                    province: text,
                                                  ));
                                            }
                                          });
                                          provinceSelected = text;
                                        }
                                      },
                                      _model,
                                    ),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2.5,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: 15,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Text(
                                "Marino Costera",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: MediaQuery.of(context).size.width / 2.5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Image.asset(
                                'assets/images/logo-coe-96x96.png',
                                height: 60.0,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 3,
                            left: MediaQuery.of(context).size.width / 1.8,
                            child: Text(
                              "Fuente:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 2.8,
                            left: MediaQuery.of(context).size.width / 1.8,
                            child: InkWell(
                              onTap: () {
                                app.navigateToWebView(
                                    context,
                                    "https://onamet.gob.do/index.php/pronosticos/informe-marino",
                                    "https://onamet.gob.do/index.php/pronosticos/informe-marino");
                              },
                              child: PNetworkImage(
                                "https://onamet.gob.do/images/Logos/onamet-500X110.png",
                                height: 30,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.only(right: 5, left: 5),
                        color: secondaryColor,
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                _model.projectText,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.visible,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5)
                          ],
                        ),
                      ),
                      Divider(height: 2),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  app.navigateToWebView(
                                      context,
                                      "https://www.caribbeanbiodiversityfund.org/",
                                      "https://www.caribbeanbiodiversityfund.org/");
                                },
                                child: PNetworkImage(
                                  "${GlobalState.getInstance().baseUrlImage}/CBF_Logo_2.jpeg",
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.scaleDown,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Divider(height: 2),
                      SizedBox(height: 1),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(top: 2),
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _model.coasts.length,
                            itemBuilder: (context, index) {
                              return _buildCoastItem(index);
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 2,
                                endIndent: 1,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              bottomNavigationBar: null,
            ),
          );
  }

  Widget _buildCoastItem(int index) {
    Map article = _model.coasts[index];
    return InkWell(
      onTap: () {
        app.navigateToWithWidget(context, article["title"],
            RecommendationCoastPageView(data: article));
      },
      child: Container(
        color: whiteColor,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 5.0, left: 10, bottom: 5),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    width: 30,
                    child: null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: article["color"] == "red"
                          ? redColor
                          : article["color"] == "yellow"
                              ? yellowColor
                              : article["color"] == "green"
                                  ? greenColor
                                  : Colors.transparent,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Flexible(
                    child: Container(
                      child: Text(
                        article["title"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
