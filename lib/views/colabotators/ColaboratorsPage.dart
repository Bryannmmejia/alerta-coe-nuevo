import 'package:alertacoe/assets/network_image.dart';
import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:flutter/material.dart';
import '../../helper/globalState.dart';

class CollaboratorsPage extends StatefulWidget {
  _CollaboratorsPageState createState() => _CollaboratorsPageState();
}

class _CollaboratorsPageState extends State<CollaboratorsPage> {
  static final List<List<Map>> _data = [
    [
      {
        "img": "logoscolaboradores/Logo_CNS.png",
        "url": "https://sismologico.uasd.edu.do"
      },
      {
        "img": "logoscolaboradores/logomsp.png",
        "url": "https://www.msp.gob.do/web/"
      },
    ],
    [
      {
        "img": "logoscolaboradores/Logo_SNG.png",
        "url": "https://www.sgn.gob.do"
      },
      {
        "img": "logoscolaboradores/logo_INDRHI.png",
        "url": "https://indrhi.gob.do"
      },
    ],
    [
      {
        "img": "logoscolaboradores/onamet-logo.png",
        "url": "https://onamet.gob.do/"
      },
      {
        "img": "logoscolaboradores/defensa_civil.png",
        "url": "http://www.defensacivil.gob.do/"
      },
    ]
  ];
  var app = ApplicationDefault();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          fit: StackFit.loose,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.blue[300]),
              child: PNetworkImage(
                  GlobalState.getInstance().baseUrlImage + "logo-coe.png", width: MediaQuery.of(context).size.width, fit: BoxFit.cover, height: MediaQuery.of(context).size.height / 4,),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        for (int i = 0; i < _data.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    app.navigateToWebView(
                      context,
                      _data[i][0]["url"],
                      _data[i][0]["url"],
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 2,
                    child: PNetworkImage(
                      GlobalState.getInstance().baseUrlImage +
                          _data[i][0]["img"],
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 6,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    app.navigateToWebView(
                        context, _data[i][1]["url"], _data[i][1]["url"]);
                  },
                  child: Container(
                    child: PNetworkImage(
                      GlobalState.getInstance().baseUrlImage +
                          _data[i][1]["img"],
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 6,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}
