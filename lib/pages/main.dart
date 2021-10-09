import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cm/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main_tabs/issues.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Tab> tabs = <Tab>[
    Tab(text: 'Заявки'),
    Tab(text: 'Карта'),
    Tab(text: 'Уведомления'),
    Tab(text: 'Настройки'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: TabBar(
              tabs: tabs,
            ),
          ),
        ),
        body: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/icons/background-tree.png",
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            TabBarView(
              children: [
                IssuesTab(),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
