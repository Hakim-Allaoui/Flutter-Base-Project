import 'package:baseproject/utils/ads_helper.dart';
import 'package:baseproject/utils/navigator.dart';
import 'package:baseproject/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Ads ads;

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
                  Text(
                    'App name',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
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
                    onPressed: () {},
                    text: "More Apps",
                    blockButton: true,
                    fullWidthButton: true,
                    shape: GFButtonShape.pills,
                    size: GFSize.LARGE,
                    type: GFButtonType.outline,
                  ),
                  GFButton(
                    onPressed: () {},
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
