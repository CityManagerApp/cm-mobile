import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';

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

    return ['$aStart-$aEnd', '$mStart-$mEnd', '$bStart-$bEnd'];
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
            Row(children: [
              IconButton(
                icon: Icon(Icons.arrow_upward_outlined),
                onPressed: () {
                  var currentId = intervals.indexOf(interval);
                  if (currentId == 0) {
                    print('cur id = 0');
                    List<double> cur = disassembleInterval(interval);
                    double curStart = cur[0];
                    double curEnd = cur[1];
                    double curMid = (cur[0] + cur[1]) / 2;
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
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: TextEditingController(
                    text: intervals[intervals.indexOf(interval)],
                  ),
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.edit_road),
                    suffixIcon: Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddMacroinfoText(currentInterval: interval),
                              ),
                            );
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
              IconButton(
                icon: Icon(Icons.arrow_downward_outlined),
                onPressed: () {
                  var currentId = intervals.indexOf(interval);
                  if (currentId == intervals.length - 1) {
                    print('cur id = intervals len');
                    List<double> cur = disassembleInterval(interval);
                    double curStart = cur[0];
                    double curEnd = cur[1];
                    double curMid = (cur[0] + cur[1]) / 2;
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
        addInterval(
          interval:
              '${toJsonObject(global['container_scanned']['meta'])['depth_start']}-'
              '${toJsonObject(global['container_scanned']['meta'])['depth_end']}',
        );
        // addInterval(
        //   interval: '1007-1015',
        // );
        // addInterval(
        //   interval: '1016-1023',
        // );
        return;
      }
      // print('macros ${macros[0]}');
      for (var m in macros) {
        print('${toJsonObject(m['meta'])['depth_start']}-'
            '${toJsonObject(m['meta'])['depth_end']}');
        addInterval(
            interval: '${toJsonObject(m['meta'])['depth_start']}-'
                '${toJsonObject(m['meta'])['depth_end']}');
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
          title: Text(MyApp.title),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 24,
                        height: MediaQuery.of(context).size.height / 6,
                        child: OutlineButton(
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => AddPhotosPage(),
                          )),
                          padding: EdgeInsets.all(10.0),
                          borderSide: BorderSide(color: Colors.blue),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.blue,
                                size: 64,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height * 5 / 6 - 100,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...intervalElements,
                              SizedBox(
                                height: 20,
                              ),
                              OutlineButton(
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
                                },
                                padding: EdgeInsets.all(10.0),
                                borderSide: BorderSide(color: Colors.blue),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                ),
                                child: Row(
                                  // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Icon(
                                      Icons.upload_outlined,
                                      color: Colors.blue,
                                      size: 64,
                                    ),
                                    SizedBox(width: 24),
                                    Text("Сдать макроописания",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 22,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 64 + 8.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                        color: Color(0xff93b8f6).withOpacity(0.4),
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
double drawerSurfaceRatio = 0.75;

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
                : Colors.blueAccent.withOpacity(0.8),
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
                Column(
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
                        '${toJsonObject(global['field_scanned']['meta'])['label_name']['label']}:\t${toJsonObject(global['field_scanned']['meta'])['name']}\n'
                        '${toJsonObject(global['well_scanned']['meta'])['label_name']['label']}:\t${toJsonObject(global['well_scanned']['meta'])['name']}\n'
                        '${toJsonObject(global['well_scanned']['meta'])['label_customer']['label']}:\t${toJsonObject(global['well_scanned']['meta'])['customer']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_name']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['depth_start']}-${toJsonObject(global['interval_scanned']['meta'])['depth_end']}\n'
                        'Интервал отбора:\t${toJsonObject(global['container_scanned']['meta'])['depth_start']}-${toJsonObject(global['container_scanned']['meta'])['depth_end']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['label_storage_number']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['storage_number']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['label_line']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['line']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['label_section']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['section']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['label_row']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['row']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['label_in_interval_number']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['in_interval_number']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['label_container_number']['label']}:\t${toJsonObject(global['container_scanned']['meta'])['container_number']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_total_length']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['total_length']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_extract_length']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['extract_length']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_extract_reason']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['extract_reason']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_kern_extract_equipment']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['kern_extract_equipment']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_containers_count']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['containers_count']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_extract_date']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['extract_date']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_arrival_date']['label']}:\t${toJsonObject(global['interval_scanned']['meta'])['arrival_date']}\n',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
