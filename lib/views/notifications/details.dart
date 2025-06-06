import 'dart:io';

import 'package:flutter/material.dart';
import 'index.dart';
import '../../assets/network_image.dart';

class AnimationOneDetails extends StatelessWidget {
  final int index;

  const AnimationOneDetails({required Key key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
              tag: "image$index",
              child: PNetworkImage(images[index], fit: BoxFit.cover, height: 200, width: 200,)),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Spacer(),
                SizedBox(height: 10.0),
                Hero(
                  tag: "title$index",
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(notifications[index]["title"], style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
                SizedBox(height: 20.0),
                Hero(
                  tag: "price$index",
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(notifications[index]['price'], textAlign: TextAlign.start, style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
