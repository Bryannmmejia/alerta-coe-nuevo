import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:social_share/social_share.dart';
import '../../assets/network_image.dart';

class BlogPageView extends StatefulWidget {
  final dynamic model;
  final List<String> images;

  const BlogPageView({Key? key, required this.model, required this.images}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPageView> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Simulación de obtención de versión de plataforma
    // ignore: unused_local_variable
    String platformVersion = Platform.operatingSystem;
    if (!mounted) return;
    setState(() {
    });

    print(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model["header"] ?? ""),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 300,
                  width: double.infinity,
                  child: PNetworkImage(
                    widget.model["image"] == "aviso"
                        ? widget.images[0]
                        : (widget.images.length > 1 ? widget.images[1] : widget.images[0]),
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(widget.model["date"] ?? ""),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () => _onShare(context),
                      )
                    ],
                  ),
                  Text(
                    widget.model["title"] ?? "",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.model["text"] ?? "",
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onShare(context) async {
    SocialShare.shareOptions(widget.model["text"] ?? "").then((data) {
      print(data);
    });
  }
}
