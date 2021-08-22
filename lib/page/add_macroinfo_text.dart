import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';
import 'package:image_cropper/image_cropper.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:clik/network.dart';

import 'package:image_picker/image_picker.dart';

class AddMacroinfoText extends StatefulWidget {
  final String currentInterval;

  AddMacroinfoText({Key key, @required this.currentInterval}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddMacroinfoText();
}

class _AddMacroinfoText extends State<AddMacroinfoText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              controller: TextEditingController(
                text: widget.currentInterval,
              ),
              onChanged: (text) {
                global["macroinfo_text_description:${widget.currentInterval}"] =
                    text;
              },
              decoration: InputDecoration(
                // prefixIcon: Icon(Icons.edit_road),
                suffixIcon: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        print('макро edit');
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.none,
            ),
          ],
        ),
      ),
    );
  }
}
