import 'package:baseproject/pages/content.dart';
import 'package:baseproject/pages/more_apps.dart';
import 'package:flutter/material.dart';
import 'package:baseproject/pages/home.dart';

class MyNavigator {
  static void goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  static void start(BuildContext context) {
    Navigator.pushNamed(context, '/start');
  }

  static void moreApps(BuildContext context) {
    Navigator.pushNamed(context, '/moreApps');
  }
}

var routes = <String, WidgetBuilder>{
  '/home': (BuildContext context) => HomeScreen(),
  '/start': (BuildContext context) => ContentScreen(),
  '/moreApps': (BuildContext context) => MoreApps(),
};
