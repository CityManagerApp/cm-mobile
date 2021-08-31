import 'dart:convert';

import 'package:clik/page/kern_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:clik/widget/button_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        resizeToAvoidBottomPadding: false,
        // appBar: AppBar(
        //   title: Text(MyApp.title),
        //   toolbarHeight: 48,
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.settings),
                  iconSize: 24,
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  color: Color(0xff646667),
                ),
              ),
              Text(
                "Добро пожаловать!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Для начала работы\nотсканируй QR с обьекта",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff646667),
                ),
              ),
              SizedBox(height: 26),
              SizedBox(
                child: Image(
                  image: AssetImage('assets/icons/welcome.png'),
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
              ),
              // SvgPicture.asset('assets/icons/welcome-optimized.svg'),
              SizedBox(height: 20),
              ButtonWidget(
                text: 'СКАНИРОВАТЬ',
                onClicked: () => scanQRCode(),
              ),
              SizedBox(height: 24),
              // Text(
              //   'debug: $qrCode',
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: Theme.of(context).accentColor,
              //   ),
              // ),
            ],
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#AEDBFF',
        ' ',
        true,
        ScanMode.DEFAULT,
      );

      if (!mounted || qrCode == "-1") return;

      setState(() {
        this.qrCode = qrCode;
        global["container_uuid"] = qrCode;
      });
      List<dynamic> box =
          jsonDecode(await getContainerDescription(containerId: qrCode));
      box.forEach((elem) {
        global[elem['type'].toLowerCase() + '_scanned'] = elem;
        print('set ${elem['type'].toLowerCase() + '_scanned'}');
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => KernPage(),
      ));
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}

showAlertDialog(BuildContext context) {
  final urlTextFieldController = TextEditingController(
    text: global["server_url"],
  );

  Widget cancelButton = TextButton(
    child: Text("Установить по-умолчанию"),
    onPressed: () {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: 'Успешно установлен адрес сервера по-умолчанию!');
      global["server_url"] = global["server_url_default"];
    },
  );
  Widget doneButton = TextButton(
    child: Text("Установить адрес сервера"),
    onPressed: () {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: 'Указанный адрес сервера успешно установлен!');
      global["server_url"] = urlTextFieldController.text;
    },
  );

  AlertDialog alert = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Настройка адреса сервера",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: urlTextFieldController,
          style: TextStyle(
            fontSize: 12,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
        ),
      ],
    ),
    actions: [
      cancelButton,
      doneButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
