import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clik/page/qr_scan_page.dart';
import 'package:clik/widget/button_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

var global = new Map<String, dynamic>(); // for all global vars

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'ЦЛИК (v1.1.6)';

  @override
  Widget build(BuildContext context) {
    global["server_url_default"] = "https://webuser:webuser@kernlab.devogip.ru";
    global["server_url"] = global["server_url_default"];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: const Color(0xff2ECC71),
        bottomAppBarColor: const Color(0xffE5E5E5),
        scaffoldBackgroundColor: const Color(0xffE5E5E5),
        backgroundColor: const Color(0xffE5E5E5),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: QRScanPage(),
      // home: MainPage(title: title),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        toolbarHeight: 48,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
              text: 'Начать',
              onClicked: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => QRScanPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
