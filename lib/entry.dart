import 'package:cm/pages/auth.dart';
import 'package:cm/pages/main.dart';
import 'package:cm/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cm/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(EntryPoint());
}

class EntryPoint extends StatelessWidget {
  static final String title = 'City Manager [v0.0.1]';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        buttonColor: const Color(0xffFFB800),
        accentColor: const Color(0xffE5E5E5),
        primaryColor: const Color(0xff74cfb8),
        backgroundColor: const Color(0xffbbdfcc),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      // home: AuthPage(),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
