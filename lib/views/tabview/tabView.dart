import 'package:flutter/material.dart';

import '../../application_localizations.dart';

class MyTabView extends StatelessWidget {
  const MyTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.yellowAccent,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              color: Colors.white,
              child: Center(child: Text('Tab 1')),
            ),
            Container(
              color: Colors.white,
              child: Center(child: Text('Tab 2')),
            ),
            Container(
              color: Colors.white,
              child: Center(child: Text('Tab 3')),
            ),
            Container(
              color: Colors.white,
              child: Center(child: Text('Tab 4')),
            ),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.white,
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.check),
                text: ApplicationLocalizations.of(context)
                        ?.translate("menu_tab_option_1") ??
                    "Tab 1",
              ),
              Tab(
                icon: Icon(Icons.toc),
                text: ApplicationLocalizations.of(context)
                        ?.translate("menu_tab_option_2") ??
                    "Tab 2",
              ),
              Tab(
                icon: Icon(Icons.mobile_friendly),
                text: ApplicationLocalizations.of(context)
                        ?.translate("menu_tab_option_3") ??
                    "Tab 3",
              ),
              Tab(
                icon: Icon(Icons.remove_red_eye),
                text: ApplicationLocalizations.of(context)
                        ?.translate("menu_tab_option_4") ??
                    "Tab 4",
              ),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.redAccent[700],
            onTap: (index) {
              // Puedes manejar el cambio de pestaña aquí si lo necesitas
            },
          ),
        ),
      ),
    );
  }
}
