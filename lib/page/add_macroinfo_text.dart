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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).accentColor,
                  width: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                child: TextField(
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.0,
                  ),
                  controller: TextEditingController(
                    text: global.containsKey(
                            "macroinfo_text_description:${widget.currentInterval}")
                        ? global[
                            "macroinfo_text_description:${widget.currentInterval}"]
                        : 'Пустое описание.',
                  ),
                  onChanged: (text) {
                    global["macroinfo_text_description:${widget.currentInterval}"] =
                        text;
                  },
                  decoration: InputDecoration.collapsed(
                      hintText: 'Ожидается описание интервала.'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,
                  autofocus: true,
                  textInputAction: TextInputAction.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
