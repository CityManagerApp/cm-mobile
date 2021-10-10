import 'package:cm/pages/auth.dart';
import 'package:cm/pages/main.dart';
import 'package:cm/pages/new_issue.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arg = settings.arguments;

    switch (settings.name) {
      case '/auth':
        return MaterialPageRoute(builder: (_) => AuthPage());
      case '/main':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/new_issue':
        return MaterialPageRoute(builder: (_) => NewIssuePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('ROUTING ERROR'),
          ),
          body: Center(
            child: Text('Routing error: something bad happened :<'),
          ),
        );
      },
    );
  }
}
