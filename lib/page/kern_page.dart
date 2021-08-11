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
  @override
  Widget build(BuildContext context) {
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
                              'name: \t${global['box_scanned']['meta']['name']}\n'
                              'row: \t${global['box_scanned']['meta']['location']['row']}\n'
                              'line: \t${global['box_scanned']['meta']['location']['line']}\n'
                              'date: \t${global['box_scanned']['meta']['date_time']}\n',
                              style: TextStyle(
                                fontSize: 22,
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
