import 'package:baseproject/pages/home.dart';
import 'package:baseproject/utils/ads_helper.dart';
import 'package:baseproject/utils/navigator.dart';
import 'package:baseproject/utils/tools.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Tools.initFire();
  await Tools.initAppSettings();
  await Ads.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Base Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: routes,
    );
  }
}
