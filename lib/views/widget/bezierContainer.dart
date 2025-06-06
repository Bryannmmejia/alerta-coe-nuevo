import 'dart:math';

import 'package:flutter/material.dart';

import 'customClipper.dart';
import '../../helper/constants.dart';

class BezierContainer extends StatelessWidget {
  const BezierContainer({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: -pi / 3.9,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height * .9,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kPrimaryColor, kPrimaryColor, blue_logo_coe],
            ),
          ),
        ),
      ),
    ));
  }
}
