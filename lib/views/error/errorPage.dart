import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(
          height: 200,
        ),
        Text(
          "OOPS, Something went wrong!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton.icon(
            onPressed: () {}, icon: Icon(Icons.error), label: Text("Try Again"))
      ],
    )));
  }
}
