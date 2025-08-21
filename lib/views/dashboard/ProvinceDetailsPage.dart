import 'package:flutter/material.dart';

class ProvinceDetailsPage extends StatefulWidget {
  final BuildContext buildContext;

  ProvinceDetailsPage(this.buildContext);

  @override
  ProvinceDetailsPageState createState() => ProvinceDetailsPageState();
}

class ProvinceDetailsPageState extends State<ProvinceDetailsPage> {

  @override
  void initState() {
    super.initState();
    showModalBottomSheet(
      context: widget.buildContext,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(100.0)),
      ),
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(widget.buildContext).size.height * 0.4,
          width: MediaQuery.of(widget.buildContext).size.width,
          color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
              color: Colors.white,
                              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Hola"),
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
    return Container(
      child: null,
    );
  }
}
