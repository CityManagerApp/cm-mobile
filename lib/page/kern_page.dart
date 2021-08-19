import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:clik/network.dart';

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
  @override
  Widget build(BuildContext context) {
    // request_box_intervals(box_uuid: global['box_scanned']['meta']['name']);

    double height = MediaQuery.of(context).size.height;
    double swipeDetectionThreshold = 100;

    return SafeArea(
      child: Scaffold(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 128,
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
                              SizedBox(height: 8),
                              Text("Добавить фотографию",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 25,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      OutlineButton(
                        onPressed: () => {print('edit intervals')},
                        padding: EdgeInsets.all(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.edit_outlined, color: Colors.blue),
                            SizedBox(height: 8),
                            Text("Интервалы",
                                style: TextStyle(
                                  color: Colors.blue,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 72),
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
                        'МЕСТОРОЖДЕНИЕ:\t${toJsonItem(global['field_scanned']['name'])}\n'
                        'НОМЕР СКВАЖИНЫ:\t${toJsonItem(global['well_scanned']['name'])}\n'
                        'ОБЩИЙ ИНТЕРВАЛ:\t${toJsonObject(global['interval_scanned']['meta'])['depth_start']}-${toJsonObject(global['interval_scanned']['meta'])['depth_end']}\n'
                        'ИНТЕРВАЛ ОТБОРА:\t${toJsonObject(global['container_scanned']['meta'])['depth_start']}-${toJsonObject(global['container_scanned']['meta'])['depth_end']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['storage_json']['label_line']}:\t${toJsonObject(global['container_scanned']['meta'])['storage_json']['line']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['storage_json']['label_section']}:\t${toJsonObject(global['container_scanned']['meta'])['storage_json']['section']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['storage_json']['label_row']}:\t${toJsonObject(global['container_scanned']['meta'])['storage_json']['row']}\n'
                        '${toJsonObject(global['container_scanned']['meta'])['label_in_interval_number']}:\t${toJsonObject(global['container_scanned']['meta'])['in_interval_number']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_total_length']}:\t${toJsonObject(global['interval_scanned']['meta'])['total_length']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_extract_length']}:\t${toJsonObject(global['interval_scanned']['meta'])['extract_length']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_extract_reason']}:\t${toJsonObject(global['interval_scanned']['meta'])['extract_reason']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_kern_extract_equipment']}:\t${toJsonObject(global['interval_scanned']['meta'])['kern_extract_equipment']}\n'
                        '${toJsonObject(global['interval_scanned']['meta'])['label_containers_count']}:\t${toJsonObject(global['interval_scanned']['meta'])['containers_count']}\n',
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
