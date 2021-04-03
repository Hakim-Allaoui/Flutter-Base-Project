import 'package:baseproject/pages/home.dart';
import 'package:baseproject/utils/navigator.dart';
import 'package:baseproject/utils/tools.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Tools.initAppSettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Tools.packageInfo.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: routes,
    );
  }
}
