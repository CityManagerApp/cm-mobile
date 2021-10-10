import 'package:cm/pages/main_tabs/notifications.dart';
import 'package:cm/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cm/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main_tabs/issues.dart';
import 'main_tabs/map.dart';
import 'main_tabs/settings.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Tab> tabs = <Tab>[
    Tab(text: '🏠'),
    Tab(text: '🗺'),
    Tab(text: '🔔'),
    Tab(text: '⚙️'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomStart,
          children: [
            BackgroundColorWidget(),
            BackgroundImageWidget(),
            TabBarView(children: [
              IssuesTab(),
              MapTab(),
              NotificationsTab(),
              SettingsTab(),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 32, top: 8),
              child: Container(
                height: 62,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TabBar(
                  tabs: tabs,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
