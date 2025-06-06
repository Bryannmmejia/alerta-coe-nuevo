import 'package:alertacoe/helper/globalState.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import '../../assets/network_image.dart';

class RecommendationCoastPageView extends StatefulWidget {
  @override
  _RecommendationCoastPageViewState createState() =>
      _RecommendationCoastPageViewState();

  final dynamic data;

  RecommendationCoastPageView({this.data}) : super();
}

class _RecommendationCoastPageViewState
    extends State<RecommendationCoastPageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              child: PNetworkImage(
                "${GlobalState.getInstance().baseUrlImage}bg_cover_recomendation.jpeg",
                fit: BoxFit.cover, height: 200, width: 200,
              ),
            ),
            Positioned(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "COE",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(this.widget.data["date"]),
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () => _onShare(context),
                  )
                ],
              ),
              Text(
                this.widget.data["subject"],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                this.widget.data["recommendationText"],
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onShare(context) async {
    SocialShare.shareOptions(this.widget.data["recommendationText"])
        .then((data) {
      //print(data);
    });
    // await screenshotController.capture().then((image) async {
    //   SocialShare.shareOptions("Hello world").then((data) {
    //     print(data);
    //   });
    // });
  }
}
