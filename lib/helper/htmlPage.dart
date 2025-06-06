import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlPage extends StatelessWidget {
  final String html;

  HtmlPage({required this.html});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(children: <Widget>[
      Html(
        data: html,
        style: {
          "html": Style(backgroundColor: Colors.white10),
          "table": Style(
            backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
          ),
          "tr": Style(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          "th": Style(
              padding: HtmlPaddings.all(6),
              backgroundColor: Colors.green[50],
              color: Colors.black),
          "td": Style(padding: HtmlPaddings.all(6), fontSize: FontSize.larger),
          "var": Style(fontFamily: 'serif'),
        //onLinkTap: (url) {},
        //onImageTap: (src) {},
        // The 'onImageError' parameter is not supported in flutter_html's Html widget.
        }
      )
    ]));
  }
}
