import 'package:flutter/material.dart';

class Ads {
  static String adNetwork = "fb";

  String admobInter1 = "";
  String admobInter2 = "";
  String admobBanner1 = "";
  String admobBanner2 = "";
  String admobNative1 = "";
  String admobNative2 = "";

  String fbInter1 = "";
  String fbInter2 = "";
  String fbBanner1 = "";
  String fbBanner2 = "";
  String fbNative1 = "";
  String fbNative2 = "";
  String fbNativeBanner1 = "";
  String fbNativeBanner2 = "";

  String startAppId = "";

  static init() {
    switch (adNetwork) {
      case "fb":
        break;
      case "admob":
        break;
      case "unity":
        break;
      case "startapp":
        break;
    }
  }

  loadInter() {}

  showInter() {}

  Widget banner() {
    return SizedBox();
  }

  Widget nativeBanner() {
    return SizedBox();
  }

  Widget native() {
    return SizedBox();
  }
}
