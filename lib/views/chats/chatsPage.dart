import 'package:flutter/material.dart';
import 'package:alertacoe/helper/globalState.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:alertacoe/models/ChatUsersModel.dart';
import 'package:alertacoe/viewModels/eventEmitterModel.dart';
import 'package:alertacoe/views/chats/conversationListPage.dart';
import 'package:provider/provider.dart';

import 'availablePage.dart';

class ChatsPageView extends StatelessWidget {
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
          return ChatPage();
        }));
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsersModel> rooms = [];

  @override
  void initState() {
    super.initState();
    try {
      SocketClient.subscribe("onChats", (dynamic ev) {
        var info = (ev as List<dynamic>)
            .map((e) => ChatUsersModel.fromJson(e))
            .toList();
        if (this.mounted) {
          setState(() {
            rooms = info;
          });
        }
      });
      SocketClient.emit("onChats",
          arguments: {"username": GlobalState.getInstance().logonResult.username});
    } catch (e) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                      "Chats",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AvailableChatsPageView();
                              }));
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.pink,
                              size: 23,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
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
              itemCount: rooms.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationListPage(
                  name: rooms[index].toUserInfo == null
                      ? ""
                      : rooms[index].toUserInfo["fullName"],
                  messageText: rooms[index].lastMessage ?? '',
                  chatRoom: rooms[index].toJson(),
                  imageUrl: rooms[index].toUserInfo == null
                      ? ""
                      : rooms[index].toUserInfo["picture"],
                  time: rooms[index].time ?? '',
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
