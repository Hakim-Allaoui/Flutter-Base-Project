import 'package:baseproject/utils/ads_helper.dart';
import 'package:baseproject/utils/navigator.dart';
import 'package:baseproject/utils/tools.dart';
import 'package:baseproject/widgets/rate_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Ads ads;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    // Tools.checkAppVersion(context);
    ads = new Ads();
    ads.loadInter();
  }

  @override
  Widget build(BuildContext context) {
    Tools.getDeviceDimensions(context);
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Tools.width,
              child: Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/burger_menu.svg',
                      height: Tools.width * 0.05,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Text(
                      Tools.packageInfo.appName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow[700],
                      ),
                    ),
                    onPressed: () async {
                      int count = 0;
                      await showDialog(
                          context: context,
                          builder: (_) => RatingDialog()).then((value) async {
                        count = value ?? 0;
                        if (value == null || value <= 3) {
                          ads.showInter();
                          await ads.loadInter();
                          return;
                        }
                      });
                      String text = '';
                      if (count <= 2)
                        text = 'Your rating was $count ☹ alright, thank you.';
                      if (count == 3) text = 'Thanks for your rating 🙂';
                      if (count >= 4) text = 'Thanks for your rating 😀';
                      scaffoldKey.currentState.showSnackBar(
                        new SnackBar(
                          content: Text(text),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(child: ads.getNativeAd()),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GFButton(
                    onPressed: () async {
                      await ads.showInter();
                      MyNavigator.start(context);
                    },
                    text: "START",
                    blockButton: true,
                    fullWidthButton: true,
                    shape: GFButtonShape.pills,
                    size: GFSize.LARGE,
                  ),
                  GFButton(
                    onPressed: () {
                      MyNavigator.moreApps(context);
                    },
                    text: "More Apps",
                    blockButton: true,
                    fullWidthButton: true,
                    shape: GFButtonShape.pills,
                    size: GFSize.LARGE,
                    type: GFButtonType.outline,
                  ),
                  GFButton(
                    onPressed: () {
                      Share.share(
                          'Check out this great app https://play.google.com/store/apps/details?id=${Tools.packageInfo.packageName}');
                    },
                    text: "Share",
                    blockButton: true,
                    fullWidthButton: true,
                    shape: GFButtonShape.pills,
                    size: GFSize.LARGE,
                    type: GFButtonType.outline,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
