import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:clik/network.dart';

import 'add_photos_page.dart';

class KernPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KernPage();
}

class _KernPage extends State<KernPage> {
  toJsonItem(String s) {
    var l = s.runes.toList();
    return utf8.decode(l);
  }

  toJsonObject(String s) {
    var l = s.runes.toList();
    return json.decode(utf8.decode(l));
  }

  @override
  Widget build(BuildContext context) {
    // request_box_intervals(box_uuid: global['box_scanned']['meta']['name']);

    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Stack(
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
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
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
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              child: Icon(
                Icons.arrow_drop_up_rounded,
                size: 56,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.all_inbox_rounded),
                            title: Text('Описание ящика:'),
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
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of()

    return Container();
  }
}
