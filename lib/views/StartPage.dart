import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:flutter/material.dart';
import 'dashboard/mapPage.dart';
import 'package:alertacoe/views/dashboard/DashBoardPage.dart';

class StartPageView extends StatefulWidget {
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPageView> {
  String _change = "local";

  @override
  void initState() {
    super.initState();
    SocketClient();
    SocketClient.subscribe("hasActiveEvent", (dynamic info) {
      print(info);
      if (this.mounted) {
        setState(() {
          GlobalState.getInstance().isEvent = info["b"];
          _change = "remote";
        });
      }
    });
    SocketClient.emit("hasActiveEvent", arguments: {});
  }

  @override
  Widget build(BuildContext context) {
    return _change == "local" && !GlobalState.getInstance().isEvent
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          )
        : _change == "remote" && !GlobalState.getInstance().isEvent
                          ? DashboardPage()
            : MapPageView();
  }
}
