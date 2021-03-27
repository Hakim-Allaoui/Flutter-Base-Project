import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Tools {
  static double height = 10.0;
  static double width = 10.0;

  static PackageInfo packageInfo = PackageInfo(
    appName: ' ',
    packageName: ' ',
    version: ' ',
    buildNumber: ' ',
  );

  static Future<void> initAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    packageInfo = info;
  }

  static var logger = Logger(
    printer: PrettyPrinter(methodCount: 1),
  );

  static launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      logger.e('Could not launch $url, error: $e');
    }
  }

  static cleanStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  static void getDeviceDimensions(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    logger.i('===> height : $height \n===> width  : $width');
  }

  static initAppSettings() async {
    cleanStatusBar();
  }
}
