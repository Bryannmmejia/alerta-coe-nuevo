import 'package:flutter/material.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:alertacoe/views/chats/chatDetailPage.dart';

// ignore: must_be_immutable
class CreateConversationPage extends StatefulWidget {
  String name;
  String imageUrl;
  String time;
  String username;

  CreateConversationPage(
      {required this.name,
      required this.imageUrl,
      required this.time,
      required this.username});

  @override
  _CreateConversationPageState createState() => _CreateConversationPageState();
}

class _CreateConversationPageState extends State<CreateConversationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SocketClient.subscribe("createRoom", (dynamic room) {
      if (this.mounted) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage(
            key: UniqueKey(),
            data: room,
          );
        }));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          var obj = {
            "fromUser": GlobalState.getInstance().logonResult.username,
            "toUser": widget.username,
            "roomId": null,
            "createDate": DateTime.now().toIso8601String(),
            "people": [],
            "roomName": '',
            "status": true,
            "lastMessage": "",
            "time": "",
            "id": null
          };
          SocketClient.emit("createRoom", arguments: obj);
        } catch (e) {}
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://racktronics.com.au/pub/static/frontend/Magento/blank/en_US/Magebuzz_Testimonial/images/default-avatar.jpg"),
                    //NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
