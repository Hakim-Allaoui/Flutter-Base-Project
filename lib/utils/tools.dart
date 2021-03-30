import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class Tools {
  static double height = 781.0909090909091;
  static double width = 392.72727272727275;

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static RemoteConfig remoteConfig;

  static PackageInfo packageInfo = PackageInfo(
    appName: ' ',
    packageName: ' ',
    version: ' ',
    buildNumber: ' ',
  );

  static initAppSettings() async {
    await initAppInfo();
    cleanStatusBar();

    logger.i("""
    height      : $height
    width       : $width
    packageName : ${packageInfo.packageName}
    appName     : ${packageInfo.appName}
    buildNumber : ${packageInfo.buildNumber}
    version     : ${packageInfo.version}""");
  }

  static Future<void> initAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    packageInfo = info;
  }

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
  }

  static var logger = Logger(
    printer: PrettyPrinter(methodCount: 1),
  );

  static initFire() async {
    await Firebase.initializeApp();
  }

  static Future<String> fetchRemoteConfig(String key) async {
    try {
      remoteConfig = await RemoteConfig.instance;
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      String body = remoteConfig.getString(key);
      logger.i('fitched config: $body');
      return body;
    } catch (e) {
      logger.e(e.toString());
      return '';
    }
  }

  static checkAppVersion(BuildContext context) async {
    try {
      String newVersion = await fetchRemoteConfig(
          '${packageInfo.packageName.replaceAll('.', '_')}_last_version');

      double currentVersion =
          double.parse(newVersion.trim().replaceAll(".", ""));
      double installedVersion =
          double.parse(packageInfo.version.trim().replaceAll(".", ""));

      logger.i(
          'currentVersion: $currentVersion \ninstalledVersion: $installedVersion');

      if (installedVersion < currentVersion) {
        showDialog(
          context: context,
          builder: (context) => Center(
            child: Scaffold(
              body: Center(
                child: GFFloatingWidget(
                  verticalPosition: Tools.height * 0.3,
                  showBlurness: true,
                  child: GFAlert(
                    title: 'Update available 🎉',
                    content:
                        'Version $newVersion is available to download. By downloading the latest version you will get the latest features, improvements and bug fixes.',
                    type: GFAlertType.rounded,
                    bottombar: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      new BorderRadius.circular(100.0),
                                  color: Colors.grey),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'later',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(100.0),
                                gradient: RadialGradient(
                                  colors: [Colors.amber, Colors.amber[200]],
                                  center: Alignment.bottomLeft,
                                  radius: 2.0,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  var url =
                                      'https://play.google.com/store/apps/details?id=' +
                                          packageInfo.packageName;
                                  launchURL(url);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      logger.e(e.toString());
    } 
  }

  static Future<String> copyDataBase() async {
    String path = '';
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      String assetFullName = 'assets/database/db_recipes.db';
      /* final Map<String, dynamic> manifestMap = jsonDecode(await manifestContent);

      final databasesPaths = manifestMap.keys
      .where((String key) => key.contains('databases/'))
      .where((String key) => key.contains('.db'))
      .toList();
      
      print("Databases :::::::::::::::::::::::::: $databasesPaths"); */

      Directory(documentsDirectory.path + '/myData').createSync();

      path = join(
          documentsDirectory.path, 'myData', assetFullName.split('/').last);
      // Only copy if the database doesn't exist
      //if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(assetFullName);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
      print("==============================> Item Copied : $path");

      /*  }else{
        print("==============================> Database Already Exist!");
      } */
    } catch (e) {
      print("Erreur Copie : $e");
    }
    return path;
  }

}
