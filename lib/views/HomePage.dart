import 'package:alertacoe/views/notifications/index.dart';
import 'package:alertacoe/views/profile/profile.dart';
import 'package:alertacoe/views/recomendations/recomendationPage.dart';
import 'package:alertacoe/views/reports/ReportsPage.dart';
import 'package:alertacoe/views/shelter/Shelters.dart';
import 'package:alertacoe/helper/applicationDefault.dart';
import 'package:alertacoe/helper/myWidgets.dart';
import 'package:alertacoe/helper/socketClient.dart';
import 'package:alertacoe/models/chatMessageModel.dart';
import 'package:alertacoe/services/HttpRequestHelper.dart';
import 'package:alertacoe/viewModels/eventEmitterModel.dart';
import 'package:alertacoe/views/chats/chatsPage.dart';

import 'package:alertacoe/views/error/errorPage.dart';
import 'package:alertacoe/views/weather/WeatherPageView.dart';
import 'package:alertacoe/views/weather/weatherPageMaster.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../application_localizations.dart';
import 'StartPage.dart';
import 'about/AboutPage.dart';
import 'colabotators/ColaboratorsPage.dart';
import 'menu/navigationDrawer.dart';
import '../helper/globalState.dart';
import '../helper/networkHelper.dart';

var app = ApplicationDefault();
var wGet = MyWidgets();
var http = HttpRequestHelper();

class DrawerItem {
  Widget title;
  String subTitle;

  DrawerItem(this.title, this.subTitle);
}

class HomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<EventEmitterModel>.value(
            value: EventEmitterModel(),
          ),
        ],
        child: Consumer<EventEmitterModel>(builder: (context, provider, child) {
          return HomePage();
        }));
  }
}

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedDrawerIndex = 0;
  List<DrawerItem> drawItems = [];
  int selectedTabIndex = 0;
  TextEditingController ticketNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Provider.of<HolderViewModel>(context, listen: false);
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    try {
      if (!await NetworkHelper.getInstance().checkConnection()) {
        app.ackAlert(context, "No hay conexión internet", title: '');
        return null;
      }

      SocketClient.subscribe("joinMe", (dynamic info) {
        if (this.mounted) {
          setState(() {
            GlobalState.getInstance().isOnline = true;
          });
        }
      });
      SocketClient.getEmitter().on("onResetMessageCounting", this, (ev, cont) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (this.mounted) {
            setState(() {
              GlobalState.getInstance().messageCount = 0;
            });
          }
        });
      });
      SocketClient.getEmitter().on("onNavigationListener", this,
          (dynamic ev, _context) {
        onSelectItem(ev.eventData["index"], false);
      });
      SocketClient.subscribe("msg-messenger", (dynamic data) {
        int count = SocketClient.getEmitter().getListenersCount("onMessage");
        var info = ChatMessageModel(
            message: data["message"],
            msgType: data["msgType"],
            type: "receiver",
            time: data["time"]);
        if (count <= 0) {
          if (this.mounted) {
            setState(() {
              GlobalState.getInstance().messageCount += 1;
            });
          }
        } else {
          SocketClient.getEmitter().emit("onMessage", this, info);
        }
      });
      SocketClient.getEmitter().on("disconnect", context, (p, d) {
        if (this.mounted) {
          setState(() {
            GlobalState.getInstance().isOnline = false;
          });
        }
      });
      SocketClient.subscribe("hasNotifications", (dynamic p) {
        if (this.mounted) {
          setState(() {
            GlobalState.getInstance().notificationsCount = p["total"];
          });
        }
      });
      SocketClient.emit("hasNotifications", arguments: {
        "username": GlobalState.getInstance().logonResult.username
      });
    } catch (e) {
      print(e);
    }
  }

  getDrawerItemWidget(int pos) {
    pos += -1; //minus 1
    switch (pos) {
      case 0:
        return UserProfilePage();
      case 1:
        return SheltersPageList(key: UniqueKey());
      case 2:
        return WeatherPageMaster();
      case 3:
        return ReportPage();
      case 4:
        return RecommendationPageList();
      case 5:
        return NotificationsPage();
      case 6:
        return CollaboratorsPage();
      case 7:
        return AboutPage();
      default:
        return ErrorPage();
    }
  }

  onSelectItem(int index, [bool closeOverlay = true]) {
    if (this.mounted) {
      setState(() {
        selectedDrawerIndex = index;
      });
    }

    if (closeOverlay) {
      Navigator.of(context).pop(); // close the drawer
    }
  }

  onTabSelectItem(int index) {
    switch (index) {
      case 0:
        return StartPageView();
      case 1:
        return SheltersPageList(key: UniqueKey());
      case 2:
        return WeatherPageView();
      case 3:
        return ChatsPageView();
      default:
        return ErrorPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EventEmitterModel>(context);
    drawItems = [
      DrawerItem(
          _buildRow(Icons.home_outlined,
              ApplicationLocalizations.of(context)?.translate("menu_option_0") ?? "Inicio"),
          ApplicationLocalizations.of(context)?.translate("menu_option_0") ?? "Inicio"),
      DrawerItem(
          _buildRow(Icons.person_outline,
              ApplicationLocalizations.of(context)?.translate("menu_option_1") ?? "Perfil"),
          ApplicationLocalizations.of(context)?.translate("menu_option_1") ?? "Perfil"),
      DrawerItem(
          _buildRow(Icons.pin_drop_outlined,
              ApplicationLocalizations.of(context)?.translate("menu_option_2") ?? "Refugios"),
          ApplicationLocalizations.of(context)?.translate("menu_option_2") ?? "Refugios"),
      DrawerItem(
          _buildRow(Icons.cloud_outlined,
              ApplicationLocalizations.of(context)?.translate("menu_option_3") ?? "Clima"),
          ApplicationLocalizations.of(context)?.translate("menu_option_3") ?? "Clima"),
      DrawerItem(
          _buildRow(Icons.videocam_outlined,
              ApplicationLocalizations.of(context)?.translate("menu_option_4") ?? "Reportes"),
          ApplicationLocalizations.of(context)?.translate("menu_option_4") ?? "Reportes"),
      DrawerItem(
          _buildRow(Icons.thumb_up_outlined,
              ApplicationLocalizations.of(context)?.translate("menu_option_6") ?? "Recomendaciones"),
          ApplicationLocalizations.of(context)?.translate("menu_option_6") ?? "Recomendaciones"),
      DrawerItem(
          _buildRow(Icons.notifications_active_outlined,
              ApplicationLocalizations.of(context)?.translate("menu_option_7") ?? "Notificaciones",
              showBadge: true),
          ApplicationLocalizations.of(context)?.translate("menu_option_7") ?? "Notificaciones"),
      DrawerItem(
          _buildRow(Icons.group_work_outlined,
              ApplicationLocalizations.of(context)?.translate("menu_option_8") ?? "Colaboradores"),
          ApplicationLocalizations.of(context)?.translate("menu_option_8") ?? "Colaboradores"),
      DrawerItem(
          _buildRow(Icons.info_outlined,
              ApplicationLocalizations.of(context)?.translate("menu_option_9") ?? "Acerca de"),
          ApplicationLocalizations.of(context)?.translate("menu_option_9") ?? "Acerca de"),
    ];
    List<Widget> drawerOptions = []; //createDrawerHeader()
    for (var i = 0; i < drawItems.length; i++) {
      var item = drawItems[i];
      drawerOptions.add(ListTile(
        title: item.title,
        contentPadding: EdgeInsets.zero,
        selected: i == selectedDrawerIndex,
        onTap: () => onSelectItem(i),
      ));
      drawerOptions.add(_buildDivider());
    }
    drawerOptions.add(ListTile(
      title: Text(GlobalState.getInstance().appVersion),
      onTap: () {},
    ));
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                selectedDrawerIndex == 0
                    ? (ApplicationLocalizations.of(context)?.translate("menu_option_0") ?? "Inicio")
                    : (selectedDrawerIndex < drawItems.length
                        ? drawItems[selectedDrawerIndex].subTitle
                        : ""),
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.network_wifi,
                      color: GlobalState.getInstance().isOnline
                          ? Colors.greenAccent[700]
                          : Colors.redAccent),
                  onPressed: () {},
                ),
                Stack(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.notifications_active),
                        onPressed: () {
                          onSelectItem(6, false);
                          setState(() {
                            GlobalState.getInstance().notificationsCount = 0;
                          });
                        }),
                    GlobalState.getInstance().notificationsCount != 0
                        ? Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                '${GlobalState.getInstance().notificationsCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ],
            ),
            drawer: menuOptions(drawerOptions, context),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedTabIndex,
              selectedItemColor: Colors.grey.shade800,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              showSelectedLabels: true,
              elevation: 8,
              onTap: (int index) {
                setState(() {
                  selectedDrawerIndex = 0;
                  selectedTabIndex = index;
                });
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    label: ApplicationLocalizations.of(context)?.translate("menu_tab_option_1") ?? "Inicio",
                    icon: Icon(Icons.home_outlined)),
                BottomNavigationBarItem(
                    label: ApplicationLocalizations.of(context)?.translate("menu_tab_option_2") ?? "Refugios",
                    icon: Icon(Icons.pin_drop_outlined)),
                BottomNavigationBarItem(
                    label: ApplicationLocalizations.of(context)?.translate("menu_tab_option_3") ?? "Clima",
                    icon: Icon(Icons.cloud_outlined)),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Icon(Icons.chat_outlined),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${GlobalState.getInstance().messageCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  label: "Chats",
                ),
              ],
            ),
            body: selectedDrawerIndex <= 0
                ? onTabSelectItem(selectedTabIndex)
                : getDrawerItemWidget(selectedDrawerIndex)));
  }

  Divider _buildDivider() {
    return Divider(
      height: 1,
      color: divider,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 14.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Icon(
          icon,
          color: active,
        ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        Spacer(),
        if (showBadge)
          Material(
            color: Colors.deepOrange,
            elevation: 5.0,
            shadowColor: Colors.red,
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                GlobalState.getInstance().notificationsCount.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
      ]),
    );
  }
}
