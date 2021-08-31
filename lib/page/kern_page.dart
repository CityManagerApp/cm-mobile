import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:clik/network.dart';

import 'add_macroinfo_text.dart';
import 'add_photos_page.dart';

toJsonItem(String s) {
  var l = s.runes.toList();
  return utf8.decode(l);
}

toJsonObject(String s) {
  var l = s.runes.toList();
  return json.decode(utf8.decode(l));
}

class KernPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KernPage();
}

class _KernPage extends State<KernPage> {
  List<Widget> intervalElements = [];
  List<String> intervals = [];
  bool macrosUploaded = false;

  List<double> disassembleInterval(String i) {
    return [double.parse(i.split('-')[0]), double.parse(i.split('-')[1])];
  }

  List<String> generateMiddleInterval(String a, String b) {
    double aStart = disassembleInterval(a)[0];
    double aEnd = disassembleInterval(a)[1];
    double bStart = disassembleInterval(b)[0];
    double bEnd = disassembleInterval(b)[1];

    double mStart, mEnd;

    print('($aStart, $aEnd)');
    print('($bStart, $bEnd)');

    if (aEnd != bStart) {
      print('first case');
      mStart = aEnd;
      mEnd = bStart;
    } else {
      print('second case');
      double d = (bEnd - aStart).abs() / 3;
      aEnd = aStart + d;
      mStart = aEnd;
      mEnd = mStart + d;
      bStart = mEnd;
    }

    print('($aStart, $aEnd)');
    print('($bStart, $bEnd)');

    return [
      '${aStart.toStringAsFixed(2)}-${aEnd.toStringAsFixed(2)}',
      '${mStart.toStringAsFixed(2)}-${mEnd.toStringAsFixed(2)}',
      '${bStart.toStringAsFixed(2)}-${bEnd.toStringAsFixed(2)}'
    ];
  }

  addInterval({
    String where,
    int id,
    String interval,
  }) {
    if (where == null) where = 'after';
    if (id == null) id = intervalElements.length - 1;

    intervals.insert(
      id + (where == 'after' ? 1 : 0),
      interval,
    );
    intervalElements.insert(
      id + (where == 'after' ? 1 : 0),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    controller: TextEditingController(
                      text: intervals[intervals.indexOf(interval)],
                    ),
                    decoration: InputDecoration(
                      suffixIcon: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddMacroinfoText(
                                      currentInterval: interval),
                                ),
                              ).then((completion) {
                                Fluttertoast.showToast(
                                  msg: 'Макроописание сохранено!',
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_up,
                ),
                onPressed: () {
                  var currentId = intervals.indexOf(interval);
                  if (currentId == 0) {
                    print('cur id = 0');
                    List<double> cur = disassembleInterval(interval);
                    String curStart = (cur[0]).toStringAsFixed(2);
                    String curEnd = (cur[1]).toStringAsFixed(2);
                    String curMid = ((cur[0] + cur[1]) / 2).toStringAsFixed(2);
                    String newCurrentInterval = '$curStart-$curMid';
                    String nextInterval = '$curMid-$curEnd';
                    setState(() {
                      intervalElements.removeAt(currentId);
                      intervals.removeAt(currentId);

                      addInterval(
                        where: 'before',
                        id: currentId,
                        interval: newCurrentInterval,
                      );
                      addInterval(
                        where: 'after',
                        id: currentId,
                        interval: nextInterval,
                      );
                    });
                    return;
                  }
                  List<String> intervalVicinity = generateMiddleInterval(
                      intervals[currentId - 1], interval);
                  String leftInterval = intervalVicinity[0];
                  String middleInterval = intervalVicinity[1];
                  String rightInterval = intervalVicinity[2];
                  setState(() {
                    intervalElements.removeAt(currentId);
                    intervals.removeAt(currentId);
                    intervalElements.removeAt(currentId - 1);
                    intervals.removeAt(currentId - 1);
                    addInterval(
                      where: 'before',
                      id: currentId - 1,
                      interval: rightInterval,
                    );
                    addInterval(
                      where: 'before',
                      id: currentId - 1,
                      interval: middleInterval,
                    );
                    addInterval(
                      where: 'before',
                      id: currentId - 1,
                      interval: leftInterval,
                    );
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                ),
                onPressed: () {
                  var currentId = intervals.indexOf(interval);
                  if (currentId == intervals.length - 1) {
                    print('cur id = intervals len');
                    List<double> cur = disassembleInterval(interval);
                    String curStart = (cur[0]).toStringAsFixed(2);
                    String curEnd = (cur[1]).toStringAsFixed(2);
                    String curMid = ((cur[0] + cur[1]) / 2).toStringAsFixed(2);
                    String newCurrentInterval = '$curStart-$curMid';
                    String nextInterval = '$curMid-$curEnd';
                    setState(() {
                      intervalElements.removeAt(currentId);
                      intervals.removeAt(currentId);

                      addInterval(
                        where: 'before',
                        id: currentId,
                        interval: newCurrentInterval,
                      );
                      addInterval(
                        where: 'after',
                        id: currentId,
                        interval: nextInterval,
                      );
                    });
                    return;
                  }
                  List<String> intervalVicinity = generateMiddleInterval(
                      interval, intervals[currentId + 1]);
                  String leftInterval = intervalVicinity[0];
                  String middleInterval = intervalVicinity[1];
                  String rightInterval = intervalVicinity[2];
                  setState(() {
                    intervalElements.removeAt(currentId + 1);
                    intervals.removeAt(currentId + 1);
                    intervalElements.removeAt(currentId);
                    intervals.removeAt(currentId);
                    addInterval(
                      where: 'before',
                      id: currentId,
                      interval: rightInterval,
                    );
                    addInterval(
                      where: 'before',
                      id: currentId,
                      interval: middleInterval,
                    );
                    addInterval(
                      where: 'before',
                      id: currentId,
                      interval: leftInterval,
                    );
                  });
                },
              ),
            ]),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );

    setState(() {});
  }

  initMacros() async {
    if (!macrosUploaded) {
      macrosUploaded = true;
      List<dynamic> macros = jsonDecode(
          await getContainerMacros(containerId: global["container_uuid"]));
      if (macros.isEmpty) {
        String interval =
            '${toJsonObject(global['container_scanned']['meta'])['depth_start']}-'
            '${toJsonObject(global['container_scanned']['meta'])['depth_end']}';
        addInterval(
          interval: interval,
        );
        return;
      }
      for (var m in macros) {
        String interval = '${toJsonObject(m['meta'])['depth_start']}-'
            '${toJsonObject(m['meta'])['depth_end']}';
        if (global.containsKey("pulled_intervals")) {
          global["pulled_intervals"].add(interval);
        } else {
          global["pulled_intervals"] = [interval];
        }
        print('init macro $interval');
        addInterval(
          interval: interval,
        );
        global["macroinfo_text_description:$interval"] =
            toJsonObject(m['meta'])['description'];
      }
    }
  }

  @override
  void initState() {
    initMacros();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // request_box_intervals(box_uuid: global['box_scanned']['meta']['name']);

    double height = MediaQuery.of(context).size.height;
    double swipeDetectionThreshold = 100;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            MyApp.title,
            style: TextStyle(
              color: Color(0xff000000),
            ),
          ),
          leading: BackButton(
            color: Colors.black,
          ),
          toolbarHeight: 56,
          backgroundColor: Theme.of(context).bottomAppBarColor,
          elevation: 3,
        ),
        body: GestureDetector(
          onPanEnd: (d) {
            if (d.velocity.pixelsPerSecond.dy > swipeDetectionThreshold) {
              this.setState(() {
                showDrawer = false;
              });
            } else if (d.velocity.pixelsPerSecond.dy <
                -swipeDetectionThreshold) {
              this.setState(() {
                showDrawer = true;
              });
            }
          },
          child: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddPhotosPage(),
                              ),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Фотографии",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Фотографии пока не загружены. "
                                  "Загрузите фотографии из галереи "
                                  "или сфотографируйте образцы керна",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff666666),
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ДОБАВИТЬ ФОТО",
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 1.0,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Интервалы",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ...intervalElements,
                          // SizedBox(
                          //   height: 8,
                          // ),
                          FlatButton(
                            onPressed: () {
                              for (String i in intervals) {
                                uploadMacro(
                                  macroInfo: <String, String>{
                                    'interval': i,
                                    'text_description': global.containsKey(
                                            "macroinfo_text_description:$i")
                                        ? global[
                                            "macroinfo_text_description:$i"]
                                        : 'Было сдано пустое описание.',
                                  },
                                  containerId: global["container_uuid"],
                                );
                              }

                              Fluttertoast.showToast(msg: 'Отправлено!');
                            },
                            padding: EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "ОТПРАВИТЬ МАКРООПИСАНИЯ",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1.0,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 64 + 8.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: drawerAnimationDuration),
                    opacity: showDrawer ? 1.0 : 0.0,
                    curve: Curves.linear,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: Container(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: drawerAnimationDuration),
                  left: 0,
                  bottom:
                      showDrawer ? -25 : -(height * drawerSurfaceRatio) + 64,
                  child: DrawerWidget(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool showDrawer = false;
const int drawerAnimationDuration = 228;
double drawerSurfaceRatio = 0.85;

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      child: AnimatedContainer(
          width: width,
          height: height * drawerSurfaceRatio,
          duration: const Duration(milliseconds: drawerAnimationDuration),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: showDrawer
                ? Color(0xff404040)
                : Theme.of(context).accentColor.withOpacity(0.8),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
            child: Column(
              children: [
                Icon(
                  showDrawer
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  size: 48,
                  color: Colors.white.withOpacity(0.75),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.all_inbox_rounded,
                            color: Colors.white,
                          ),
                          title: Text('Описание контейнера',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            // '${toJsonObject(global['field_scanned']['meta'])['label_name']['label']}:\t${toJsonObject(global['field_scanned']['meta'])['name']}\n'
                            // '${toJsonObject(global['well_scanned']['meta'])['label_name']['label']}:\t${toJsonObject(global['well_scanned']['meta'])['name']}\n'
                            // '${toJsonObject(global['well_scanned']['meta'])['label_customer']['label']}:\t${toJsonObject(global['well_scanned']['meta'])['customer']}\n'
                            // '${toJsonObject(global['interval_scanned']['meta'])['label_name']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['depth_start']}-${toJsonObject(global['interval_scanned']['meta'])['depth_end']}\n'
                            // 'Интервал отбора:\t${toJsonObject(global['container_scanned']['meta'])['depth_start']}-${toJsonObject(global['container_scanned']['meta'])['depth_end']}\n'
                            // '${toJsonObject(global['container_scanned']['meta'])['label_storage_number']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['storage_number']}\n'
                            // '${toJsonObject(global['container_scanned']['meta'])['label_line']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['line']}\t'
                            // '${toJsonObject(global['container_scanned']['meta'])['label_section']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['section']}\t'
                            // '${toJsonObject(global['container_scanned']['meta'])['label_row']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['row']}\n'
                            // '${toJsonObject(global['container_scanned']['meta'])['label_in_interval_number']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['in_interval_number']}\n'
                            // '${toJsonObject(global['container_scanned']['meta'])['label_container_number']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['container_number']}\n'
                            // '${toJsonObject(global['interval_scanned']['meta'])['label_total_length']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['total_length']}\t'
                            // '${toJsonObject(global['interval_scanned']['meta'])['label_extract_length']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['extract_length']}\n'
                            // '${toJsonObject(global['interval_scanned']['meta'])['label_extract_reason']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['extract_reason']}\n'
                            // '${toJsonObject(global['interval_scanned']['meta'])['label_kern_extract_equipment']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['kern_extract_equipment']}\n'
                            // '${toJsonObject(global['interval_scanned']['meta'])['label_containers_count']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['containers_count']}\n'
                            // '${toJsonObject(global['interval_scanned']['meta'])['label_extract_date']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['extract_date']}\n'
                            // '${toJsonObject(global['interval_scanned']['meta'])['label_arrival_date']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['arrival_date']}\n',
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "title",
                            style: TextStyle(
                              color: Color(0xffd7d7d7),
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Text(
                            "subtitle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
