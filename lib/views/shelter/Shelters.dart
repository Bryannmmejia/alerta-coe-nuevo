import 'dart:convert';

import 'package:alertacoe/assets/network_image.dart';
import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/constants.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/location.dart';
import 'package:alertacoe/helper/urlScheme.dart';
import 'package:alertacoe/models/HttpResponseModel.dart';
import 'package:alertacoe/models/SheltersModel.dart';
import 'package:flutter/material.dart';
import '../../application_localizations.dart';
import '../../services/HttpRequestHelper.dart';

var _http = HttpRequestHelper();
var app = ApplicationDefault();

class SheltersPageList extends StatefulWidget {
  SheltersPageList({required Key key}) : super(key: key);

  _SheltersPageListState createState() => _SheltersPageListState();
}

class _SheltersPageListState extends State<SheltersPageList> {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  //final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);
  List<SheltersModel> sLists = [];
  List<SheltersModel> filtered = [];
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  _waiting(bool _value) {
    if (this.mounted) {
      setState(() {
        showLoading = _value;
      });
    }
  }

  getData() async {
    try {
      var pos = await fetchLocation(context);
      _waiting(true);

      var response = await _http.getRequest(
          "apim/shelter",
          {
            "user": GlobalState.getInstance().logonResult.toJson().values,
            "coordinates": {
              "lat": pos != null ? pos.latitude.toString() : "0",
              "lng": pos != null ? pos.longitude.toString() : "0"
            }.values
          },
          token: GlobalState.getInstance().logonResult.token);
      var result = HttpResponseModel.fromJson(json.decode(response!.body));
      if (result.httpStatus == 200) {
        sLists = result.data
            .map<SheltersModel>((e) => SheltersModel.fromJson(e))
            .toList();
        if (this.mounted) {
          setState(() {
            filtered = sLists;
          });
        }
      }
      _waiting(false);
    } catch (e) {
      _waiting(false);
      app.ackAlert(context, e.toString(), title: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 80),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
              Container(
                height: 85,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightBlueColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: null,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          // controller: TextEditingController(text: locations[0]),
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              var results = sLists
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(text.toLowerCase()))
                                  .toList();
                              if (this.mounted) {
                                setState(() {
                                  filtered = results;
                                });
                              }
                            } else {
                              if (this.mounted) {
                                setState(() {
                                  filtered = sLists;
                                });
                              }
                            }
                          },
                          cursorColor: Theme.of(context).primaryColor,
                          style: dropdownMenuItem,
                          decoration: InputDecoration(
                            hintText: ApplicationLocalizations.of(context)
                                ?.translate("search_text"),
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 16),
                            prefixIcon: Material(
                              elevation: 0.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(Icons.search),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: false,
                      maintainState: false,
                      visible: showLoading,
                      child: Container(
                        margin: EdgeInsets.only(top: 50, bottom: 30),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return InkWell(
      onTap: () => {navigateToWithWidget(context, filtered[index])},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 110,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0),
                border: Border.all(width: 0, color: Colors.transparent),
                image: DecorationImage(
                    image: NetworkImage(
                        "${GlobalState.getInstance().baseUrlImage}shelters.png"),
                    fit: BoxFit.fill),
              ),
            ),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      filtered[index].name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: lightBlueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Container(
                            child: Text(
                              filtered[index].provinceName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: lightBlueColor,
                                  fontSize: 13,
                                  letterSpacing: .3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.map,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${filtered[index].distance} km",
                          style: TextStyle(
                              color: lightBlueColor,
                              fontSize: 13,
                              letterSpacing: .3),
                        ),
                      ],
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

  navigateToWithWidget(BuildContext pContext, SheltersModel data) {
    Navigator.of(pContext).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(data.name),
            ),
            body: Material(
              child: Container(
                // The blue background emphasizes that it's a new route.
                color: Colors.white,
                padding: const EdgeInsets.all(0),
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: DetailsShelter(data),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailsShelter extends StatefulWidget {
  final SheltersModel _model;

  DetailsShelter(this._model) : super();

  _DetailsShelterState createState() => _DetailsShelterState();
}

class _DetailsShelterState extends State<DetailsShelter> {
  List<Map> data = [];

  @override
  void initState() {
    super.initState();
    data = [
      {
        "label": "APTO PARA SISMO:",
        "data": widget._model.apto_terremoto ? "SI" : "NO"
      },
      {
        "label": "APTO PARA INUNDACIONES:",
        "data": widget._model.apto_inundaciones ? "SI" : "NO"
      },
      {
        "label": "CAPACIDAD MAXIMA:",
        "data": widget._model.max_capacity.toString() + " Persona"
      },
      {"label": "SUPERVISOR:", "data": widget._model.contact_name},
      {"label": "TEL. SUPERVISOR:", "data": widget._model.contact_phone_number},
      {"label": "PROVINCIA", "data": widget._model.provinceName},
      {"label": "DIRECCION", "data": widget._model.address1},
      {"label": "DISTANCIA", "data": widget._model.distance + " KM"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ListView(
              children: <Widget>[
                Row(
                  children: [
                    PNetworkImage(
                      "${GlobalState.getInstance().baseUrlImage}shelters.png",
                      height: 150,
                      width: 150, fit: BoxFit.cover,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget._model.name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star, color: Colors.yellow),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    "Descripción",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  child: Text(
                    "Albergue para Emergencia",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                for (var i in data)
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(00.0)),
                    ),
                    padding: EdgeInsets.only(left: 20.0, right: 0.0, top: 0.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            child: Text(
                              i["label"],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Container(
                            child: Text(
                              i["data"],
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 12,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(""),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: lightBlueColor,
                        elevation: 0,
                        onPressed: () {
                          UrlScheme.makePhoneCall(widget._model.phones);
                        },
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 30,
                              ), // icon
                              Text(
                                "Llamar",
                                style: TextStyle(color: Colors.white),
                              ), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: greenColor,
                        elevation: 0,
                        onPressed: () {
                          UrlScheme.launchCoordinates(
                              widget._model.lat, widget._model.lng);
                        },
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                                size: 30,
                              ), // icon
                              Text(
                                "Ir",
                                style: TextStyle(color: Colors.white),
                              ), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
