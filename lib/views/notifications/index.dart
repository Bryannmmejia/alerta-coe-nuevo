import 'dart:convert';

import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/views/notifications/blogPage.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import '../../assets/network_image.dart';

List<String> images = [
  "${GlobalState.getInstance().baseUrlImage}noti-avisos.jpeg",
  "${GlobalState.getInstance().baseUrlImage}noti-tips.jpeg"
];
List<dynamic> notifications = [];

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int prevIndex = 0;
  final SwiperController _swiperController = SwiperController();
  late final AnimationController _controller;

  var app = ApplicationDefault();
  var _http = HttpRequestHelper();
  bool isBusy = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    init();
  }

  Future<void> init() async {
    try {
      var response = await _http.getRequest(
        "apim/notifications",
        {'username': GlobalState.getInstance().logonResult.username},
        token: GlobalState.getInstance().logonResult.token,
      );
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        if (mounted) {
          setState(() {
            notifications = result.data;
            isBusy = false;
          });
        }
      } else {
        setState(() {
          isBusy = false;
        });
        app.ackAlert(context, result.message, title: '');
      }
    } catch (e) {
      setState(() {
        isBusy = false;
      });
      debugPrint(e.toString());
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        : Scaffold(
            body: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: notifications.isEmpty
                      ? Center(child: Text("No hay notificaciones"))
                      : Swiper(
                          physics: BouncingScrollPhysics(),
                          viewportFraction: 0.8,
                          itemCount: notifications.length,
                          loop: true,
                          controller: _swiperController,
                          onIndexChanged: (index) {
                            _controller.reverse();
                            setState(() {
                              prevIndex = currentIndex;
                              currentIndex = index;
                              _controller.forward();
                            });
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 16, top: 10),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              Duration(seconds: 1),
                                          pageBuilder: (_, __, ___) =>
                                              BlogPageView(
                                            model: notifications[index],
                                            images: images,
                                          ),
                                        ),
                                      ),
                                      child: Hero(
                                        tag: "image$index",
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: PNetworkImage(
                                            notifications[index]["image"] ==
                                                    "aviso"
                                                ? images[0]
                                                : images[1],
                                            fit: BoxFit.cover, height: 200, width: 200,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          pagination: SwiperPagination(
                            margin: EdgeInsets.all(5.0),
                            builder: DotSwiperPaginationBuilder(
                                size: 5,
                                activeSize: 5,
                                color: Colors.black26,
                                activeColor: Colors.blue[900]),
                          ),
                        ),
                ),
                Stack(
                  children: <Widget>[
                    notifications.isEmpty
                        ? SizedBox.shrink()
                        : _buildDesc(currentIndex)
                  ],
                )
              ],
            ),
          );
  }

  Widget _buildDesc(int index) {
    if (notifications.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.only(right: 30, left: 30),
      height: MediaQuery.of(context).size.height / 3.5,
      child: SingleChildScrollView(
        child: Text(
          notifications[index]["text"] ?? "",
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
