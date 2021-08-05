import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:clik/network.dart';

class AddPhotosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPhotosPage();
}

class _AddPhotosPage extends State<AddPhotosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 72),
            Text(
              'Box description:\n',
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'name: \t${global['box_scanned']['meta']['name']}\n'
                  'row: \t${global['box_scanned']['meta']['location']['row']}\n'
                  'line: \t${global['box_scanned']['meta']['location']['line']}\n'
                  'date: \t${global['box_scanned']['meta']['date_time']}\n',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            OutlineButton(
              onPressed: () => {print('add photo')},
              padding: EdgeInsets.all(10.0),
              borderSide: BorderSide(color: Colors.blue),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Column(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.add_a_photo_outlined, color: Colors.blue),
                  SizedBox(height: 4),
                  Text("Photos",
                      style: TextStyle(
                        color: Colors.blue,
                      )),
                ],
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
                  SizedBox(height: 4),
                  Text("Edit",
                      style: TextStyle(
                        color: Colors.blue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
