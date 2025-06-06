import 'dart:convert';

import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/views/recomendations/recomendationView.dart';
import 'package:flutter/material.dart';
import '../../helper/applicationDefault.dart';

class RecommendationPageList extends StatefulWidget {
  const RecommendationPageList({Key? key}) : super(key: key);

  @override
  _RecommendationPageListState createState() => _RecommendationPageListState();
}

class _RecommendationPageListState extends State<RecommendationPageList> {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff406b9e);
  final secondary = Color(0xfff29a94);
  var app = ApplicationDefault();
  var _http = HttpRequestHelper();
  bool isBusy = true;
  List<dynamic> recommendations = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      var response = await _http.getRequest(
        "apim/recommendation",
        {'username': GlobalState.getInstance().logonResult.username},
        token: GlobalState.getInstance().logonResult.token,
      );
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        if (mounted) {
          setState(() {
            recommendations = result.data;
            isBusy = false;
          });
        }
      } else {
        if (mounted) setState(() => isBusy = false);
        app.ackAlert(context, result.message, title: '');
      }
    } catch (e) {
      if (mounted) setState(() => isBusy = false);
      debugPrint(e.toString());
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0),
      body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 5),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: ListView.builder(
              itemCount: recommendations.length,
              itemBuilder: (BuildContext context, int index) {
                return buildList(context, index);
              },
            ),
          ),
          Center(
            child: Visibility(
              maintainSize: false,
              maintainAnimation: false,
              maintainState: false,
              visible: isBusy,
              child: Container(
                margin: const EdgeInsets.only(top: 50, bottom: 30),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        app.navigateToWithWidget(
          context,
          recommendations[index]["name"],
          RecommendationViewPage(recommendations[index]["description"]),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              child: Icon(
                Icons.thumb_up_alt_outlined,
                size: 40,
                color: primary,
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      recommendations[index]['name'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
