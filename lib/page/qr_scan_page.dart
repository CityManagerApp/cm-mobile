import 'dart:convert';

import 'package:clik/page/box_description_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:clik/network.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Результат сканирования:\n$qrCode',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 144),
              ButtonWidget(
                text: 'Сканировать',
                onClicked: () => scanQRCode(),
              ),
            ],
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      print('$qrCode');
      global['box_scanned'] = jsonDecode(await request_box_description(box_uuid: qrCode))[0];

      setState(() {
        this.qrCode = qrCode;
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => BoxDescriptionPage(),
      ));
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}
