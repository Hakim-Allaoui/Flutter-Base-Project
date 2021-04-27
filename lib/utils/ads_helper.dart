import 'package:baseproject/utils/tools.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart' as admob;
import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads.dart';
// import 'package:flutter/foundation.dart';

class Ads {
  //static String testDeviceId ="a47d5108-ce0c-4f2b-bb22-d7eea19727cd"; //Real device
  static String testDeviceId = "e5c56faf-6e34-4a4c-8f5a-e8cd07f43b2a"; //AVD

  static String adNetwork = "fb";

  static final bool debugMode = kDebugMode;

  //Admob
  static String admobBanner = debugMode
      ? MobileAds.bannerAdTestUnitId
      : "ca-app-pub-8644958469423958/9305289938";
  static String admobInter = debugMode
      ? MobileAds.interstitialAdTestUnitId
      : "ca-app-pub-8644958469423958/8870993904";
  static String admobNative = debugMode
      ? MobileAds.nativeAdTestUnitId
      : "ca-app-pub-8644958469423958/4853719662";

  InterstitialAd interstitialAd = InterstitialAd(unitId: admobInter);
  final controller = BannerAdController();

  //Facebook Ads

  String fbBanner = debugMode ? "IMG_16_9_APP_INSTALL#226395002587502_226395042587498" : "226395002587502_226395042587498";
  String fbInter = debugMode ? "IMG_16_9_APP_INSTALL#226395002587502_226395035920832" : "226395002587502_226395035920832";
  String fbNative = debugMode ? "IMG_16_9_APP_INSTALL#226395002587502_226395039254165" : "226395002587502_226395039254165";


  static String unityGameId = "4106983";
  String unityAdId = "video";

  Widget bannerAd;
  Widget nativeAd;

  bool isInterLoaded = false;

  static bool isVersionUpToLOLLIPOP() {
    bool isVersionUp = true;
    if (Tools.androidInfo.version.sdkInt <= 23) isVersionUp = false;
    return isVersionUp;
  }

  static init() async {
    adNetwork = await Tools.fetchRemoteConfig('${Tools.packageInfo.packageName.replaceAll(".", "_")}_adNetwork');
    Tools.logger.i('Initialized Ad Network: $adNetwork');
    switch (adNetwork) {
      case "fb":
        await FacebookAudienceNetwork.init(
          testingId: testDeviceId,
        );
        break;
      case "admob":
        await MobileAds.initialize(
          bannerAdUnitId: admobBanner,
          interstitialAdUnitId: admobInter,
          nativeAdUnitId: admobNative,
        );
        MobileAds.setTestDeviceIds([testDeviceId]);
        break;
      case "unity":
        break;
      case "startapp":
        break;
      default:
        break;
    }

    if (isVersionUpToLOLLIPOP() && !debugMode) {
      UnityAds.init(
        gameId: unityGameId,
        listener: (state, args) => Tools.logger.i('Unity Ads: $state => $args'),
      );
    }
  }

  loadInter() async {
    switch (adNetwork) {
      case "fb":
        FacebookInterstitialAd.loadInterstitialAd(
          placementId: fbInter,
          listener: (result, value) {
            Tools.logger.i('Fb Inter: $result\nvalue: $value');
            switch (result) {
              case InterstitialAdResult.DISMISSED:
                // FacebookInterstitialAd.loadInterstitialAd();
                isInterLoaded = false;
                break;
              case InterstitialAdResult.LOADED:
                isInterLoaded = true;
                break;
              default:
                break;
            }
          },
        );
        break;
      case "admob":
        interstitialAd.load();
        interstitialAd.onEvent.listen((e) {
          final event = e.keys.first;
          Tools.logger.e('Admob Inter: $event');
          switch (event) {
            case FullScreenAdEvent.closed:
              // interstitialAd.load();
              isInterLoaded = false;
              break;
            case FullScreenAdEvent.loaded:
              isInterLoaded = true;
              break;
            default:
              break;
          }
        });
        break;
      case "unity":
        break;
      case "startapp":
        break;
      default:
        break;
    }
  }

  showInter() async {
    switch (adNetwork) {
      case "fb":
        if (isInterLoaded) FacebookInterstitialAd.showInterstitialAd();
        break;
      case "admob":
        if (isInterLoaded) {
          if (!interstitialAd.isLoaded) await interstitialAd.load();
          if (interstitialAd.isLoaded) interstitialAd.show();
        }
        break;
      case "unity":
        break;
      case "startapp":
        break;
      default:
        break;
    }


    if (isVersionUpToLOLLIPOP()) {
      if (!isInterLoaded && !interstitialAd.isLoaded) {
        Tools.logger.wtf(
            "Adsssssss: isInterLoaded: $isInterLoaded interstitialAd.isLoaded: ${interstitialAd.isLoaded}");
        if (!debugMode) {
          await UnityAds.showVideoAd(
            placementId: 'video',
            listener: (state, args) {
              if (state == UnityAdState.complete) {
                Tools.logger
                    .i('User watched a video. User should get a reward!');
              } else if (state == UnityAdState.skipped) {
                Tools.logger.i('User cancel video.');
              }
            },
          );
        } else {
          Tools.logger.wtf('Unity Ads (Debug blocking) (kDebugMode)');
        }
      }
    } else {
      Tools.logger
          .wtf('Unity Ads instead (SDK blocking) (isVersionUpToLOLLIPOP)');
    }
  }

  Widget getBannerAd() {
    switch (adNetwork) {
      case "fb":
        if (bannerAd == null) {
          bannerAd = Container(
            height: 50.0,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.amber,
                ),
                bottom: BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            child: FacebookBannerAd(
              placementId: fbBanner,
              bannerSize: fb.BannerSize.STANDARD,
              listener: (result, value) {
                switch (result) {
                  case BannerAdResult.ERROR:
                    Tools.logger.i("Fb Banner: Error: $value");
                    break;
                  case BannerAdResult.LOADED:
                    Tools.logger.i("Fb Banner: Loaded: $value");
                    break;
                  case BannerAdResult.CLICKED:
                    Tools.logger.i("Fb Banner: Clicked: $value");
                    break;
                  case BannerAdResult.LOGGING_IMPRESSION:
                    Tools.logger.i("Fb Banner: Logging Impression: $value");
                    break;
                }
              },
            ),
          );
        }
        break;
      case "admob":
        if (bannerAd == null) {
          bannerAd = BannerAd(
            controller: controller,
            size: admob.BannerSize.ADAPTIVE,
          );
          controller.onEvent.listen((e) {
            final event = e.keys.first;
            switch (event) {
              case BannerAdEvent.loading:
                Tools.logger.i('Admob Banner: loading');
                break;
              case BannerAdEvent.loaded:
                Tools.logger.i('Admob Banner: loaded');
                break;
              case BannerAdEvent.loadFailed:
                final errorCode = e.values.first;
                Tools.logger.i('Admob Banner: loadFailed $errorCode');
                break;
              case BannerAdEvent.impression:
                Tools.logger.i('Admob Banner: ad rendered');
                break;
              default:
                break;
            }
          });
        }
        break;
      case "unity":
        break;
      case "startapp":
        break;
      default:
        break;
    }

    return bannerAd;
  }

  Widget getNativeAd({double height, double width}) {
    switch (adNetwork) {
      case 'fb':
        if (nativeAd == null) {
          nativeAd = FacebookNativeAd(
            placementId: fbNative,
            adType: NativeAdType.NATIVE_AD,
            width: width ?? Tools.width * 0.9,
            height: height ?? 300,
            backgroundColor: Colors.blue,
            titleColor: Colors.white,
            descriptionColor: Colors.white,
            buttonColor: Colors.deepPurple,
            buttonTitleColor: Colors.white,
            buttonBorderColor: Colors.white,
            keepAlive: true,
            //set true if you do not want adview to refresh on widget rebuild
            keepExpandedWhileLoading: false,
            // set false if you want to collapse the native ad view when the ad is loading
            expandAnimationDuraion: 300,
            //in milliseconds. Expands the adview with animation when ad is loaded
            listener: (result, value) {
              Tools.logger.i("Fb Native Ad: $result --> $value");
            },
          );
        }
        break;
      case 'admob':
        if (nativeAd == null) {
          nativeAd = NativeAd(
            height: height ?? 300.0,
            width: width ?? Tools.width * 0.9,
            body: AdTextView(style: TextStyle(color: Colors.black)),
            headline: AdTextView(style: TextStyle(color: Colors.black)),
            advertiser: AdTextView(style: TextStyle(color: Colors.black)),
            attribution: AdTextView(style: TextStyle(color: Colors.black)),
            price: AdTextView(style: TextStyle(color: Colors.black)),
            store: AdTextView(style: TextStyle(color: Colors.black)),
            buildLayout: adBannerLayoutBuilder,
            loading: Text('loading'),
            error: Text('error'),
          );
        }
        break;
      case "unity":
        break;
      case "startapp":
        break;
      default:
        break;
    }
    return nativeAd;
  }
}
