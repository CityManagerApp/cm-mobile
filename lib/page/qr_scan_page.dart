import 'dart:convert';

import 'package:clik/page/kern_page.dart';
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
  String qrCode = 'Unknown';

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
                'Результат сканирования:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$qrCode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: 72),
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
        '#AEDBFF',
        'Назад',
        true,
        ScanMode.DEFAULT,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
        global["container_uuid"] = qrCode;
      });

      List<dynamic> box = jsonDecode(await getContainerDescription(containerId: qrCode));
      box.forEach((elem) {
        global[elem['type'].toLowerCase() + '_scanned'] = elem;
      });


      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => KernPage(),
      ));
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}
