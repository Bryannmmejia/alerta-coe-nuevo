import 'package:flutter/material.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:alertacoe/models/newChatModel.dart';
import 'package:alertacoe/viewModels/eventEmitterModel.dart';
import '../../views/chats/createConversationPage.dart';
import 'package:provider/provider.dart';

class AvailableChatsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<EventEmitterModel>.value(
            value: EventEmitterModel(),
            //create: (context) => EventEmitter()
          )
        ],
        child: Consumer<EventEmitterModel>(builder: (context, provider, child) {
          return AvailableChatsPage();
        }));
  }
}

class AvailableChatsPage extends StatefulWidget {
  @override
  _AvailableChatsPageState createState() => _AvailableChatsPageState();
}

class _AvailableChatsPageState extends State<AvailableChatsPage> {
  List<NewChatModel> onLines = [];

  @override
  void initState() {
    super.initState();
    SocketClient.subscribe("onGetUsers", (dynamic ev) {
      var info =
          (ev as List<dynamic>).map((e) => NewChatModel.fromJson(e)).toList();
      if (this.mounted) {
        setState(() {
          onLines = info;
        });
      }
    });
    SocketClient.emit("onGetUsers",
        arguments: {"username": GlobalState.getInstance().logonResult.username});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SocketClient.unsubscribe("onGetUsers", (info) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Nueva Conversación",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            ListView.builder(
              itemCount: onLines.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CreateConversationPage(
                    name: onLines[index].fullName,
                    imageUrl: onLines[index].picture ?? '',
                    username: onLines[index].username,
                    time: onLines[index].time);
              },
            ),
          ],
        ),
      ),
    );
  }
}
