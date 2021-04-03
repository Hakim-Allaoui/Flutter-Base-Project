import 'package:baseproject/utils/ads_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:getwidget/getwidget.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Tools {
  static double height = 781.0909090909091;
  static double width = 392.72727272727275;

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static RemoteConfig remoteConfig;
  static AndroidDeviceInfo androidInfo;

  static initAppSettings() async {
    await Firebase.initializeApp();
    await initAppInfo();
    await getDeviceInfo();
    cleanStatusBar();
    await Ads.init();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    logger.i("""
    height      : $height
    width       : $width
    packageName : ${packageInfo.packageName}
    appName     : ${packageInfo.appName}
    buildNumber : ${packageInfo.buildNumber}
    version     : ${packageInfo.version}""");
  }

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

  static Future<void> getDeviceInfo() async {
    androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    Tools.logger.i(
        'Android: $release, SDK: $sdkInt, manufacturer: $manufacturer ,model: $model');
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
          'Current version: $currentVersion \nInstalled version: $installedVersion');

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

  //Firebase messaging
  static requestMessagingPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String token = await messaging.getToken(
        // vapidKey: "BGpdLRs......",
        );

    logger.i("""
    User granted permission: ${settings.authorizationStatus}
    Token: $token
    """);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('Got a message whilst in the foreground!');
      logger.i('Message data: ${message.data}');

      if (message.notification != null) {
        logger.i(
            'Message also contained a notification: ${message.notification}');
      }
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  Tools.logger.i("Handling a background message: ${message.messageId}");
}

