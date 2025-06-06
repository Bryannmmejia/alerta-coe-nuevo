import 'dart:async';

import 'package:flutter/material.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:alertacoe/models/chatMessageModel.dart';
import 'package:eventify/eventify.dart' as eventify;

class ChatDetailPage extends StatefulWidget {
  final dynamic data;

  const ChatDetailPage({required Key key, required this.data}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessageModel> messages = [];
  ScrollController _scrollController = new ScrollController();
  TextEditingController _msgController = new TextEditingController();
  late eventify.Listener listener;

  void callback(dynamic ev, Object cxt) {
    if (this.mounted) {
      setState(() {
        messages.add(ev.eventData);
      });
      Timer(Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SocketClient.subscribe("msg-get-history-by-room", (dynamic data) {
      try {
        messages = [];
        for (var item in data) {
          String _type = "receiver";
          if (item["room"]["fromUser"] == GlobalState.getInstance().logonResult.username) {
            _type = "sender";
          }
          var info = new ChatMessageModel(
              message: item["message"],
              msgType: item["msgType"],
              type: _type,
              time: item["time"]);
          if (this.mounted) {
            setState(() {
              messages.add(info);
            });
          }
        }
        Timer(
          Duration(milliseconds: 300),
          () {
            if (_scrollController.hasClients) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            }
          },
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    });
    SocketClient.emit("msg-get-history-by-room",
        arguments: {"id": this.widget.data["roomId"]});
    listener = SocketClient.getEmitter().on("onMessage", this, callback as eventify.EventCallback);
    SocketClient.getEmitter().emit("onResetMessageCounting");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    SocketClient.getEmitter().off(listener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://racktronics.com.au/pub/static/frontend/Magento/blank/en_US/Magebuzz_Testimonial/images/default-avatar.jpg"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      this
                                  .widget
                                  .data["toUserInfo"]["fullName"]
                                  .toString()
                                  .length <=
                              17
                          ? Text(
                              this
                                  .widget
                                  .data["toUserInfo"]["fullName"]
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          : Text(
                              this
                                      .widget
                                      .data["toUserInfo"]["fullName"]
                                      .toString()
                                      .substring(0, 17) +
                                  "...",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 60),
            //physics: NeverScrollableScrollPhysics(),
            controller: _scrollController,
            reverse: false,
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].type == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].type == "receiver"
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      messages[index].message,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (_msgController.text.trim().isNotEmpty) {
                        var msg = ChatMessageModel(
                          message: _msgController.text,
                          msgType: "text",
                          time: "",
                          createDate: 0,
                          id: "",
                          fileData: null,
                          messageId: "",
                          received: false,
                          room: widget.data,
                          seen: false,
                          seenDate: 0,
                          serialNumber: 0,
                          type: "sender",
                        );
                        SocketClient.emit("msg-messenger", arguments: msg.toJson());
                        setState(() {
                          messages.add(msg);
                          _msgController.text = "hola";
                        });
                        Timer(
                          Duration(milliseconds: 300),
                          () => _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
