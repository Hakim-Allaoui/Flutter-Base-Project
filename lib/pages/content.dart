import 'package:baseproject/utils/ads_helper.dart';
import 'package:baseproject/utils/constant.dart';
import 'package:baseproject/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:page_slider/page_slider.dart';

class ContentScreen extends StatefulWidget {
  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  Ads ads;
  GlobalKey<PageSliderState> _sliderKey = GlobalKey();
  String previous = "Quite";
  String next = "Next";

  @override
  void initState() {
    super.initState();
    ads = new Ads();
    ads.loadInter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: ads.getBannerAd(),
            ),
            Expanded(
              child: Card(
                elevation: 5.0,
                margin: EdgeInsets.all(10.0),
                child: PageSlider(
                  key: _sliderKey,
                  pages: articles.map((e) {
                    return Scrollbar(

                      child: SingleChildScrollView(

                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: HtmlWidget(
                            e,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: GFButton(
                      onPressed: () async {
                        if (!ads.isInterLoaded) await ads.loadInter();
                        if (_sliderKey.currentState.hasPrevious) {
                          if (_sliderKey.currentState.currentPage == 1) {
                            setState(() {
                              previous = "Quite";
                            });
                          }
                          if (_sliderKey.currentState.currentPage ==
                              articles.length - 1) {
                            setState(() {
                              next = "Next";
                            });
                          }
                          _sliderKey.currentState.previous();
                          if (_sliderKey.currentState.currentPage % 2 == 0) {
                            ads.showInter();
                            ads.loadInter();
                          }
                        } else {
                          ads.showInter();
                          Navigator.pop(context);
                        }
                      },
                      text: previous,
                      shape: GFButtonShape.pills,
                      size: GFSize.LARGE,
                      fullWidthButton: true,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: GFButton(
                      onPressed: () async {
                        Tools.logger.i(
                            "currentPage: ${_sliderKey.currentState.currentPage}\narticles.length: ${articles.length}");
                        if (!ads.isInterLoaded) await ads.loadInter();
                        if (_sliderKey.currentState.hasNext) {
                          if (_sliderKey.currentState.currentPage ==
                              articles.length - 2) {
                            setState(() {
                              next = "Replay";
                            });
                          }
                          if (_sliderKey.currentState.currentPage == 0) {
                            setState(() {
                              previous = "Previous";
                            });
                          }
                          _sliderKey.currentState.next();
                          if (_sliderKey.currentState.currentPage % 2 == 0) {
                            ads.showInter();
                            ads.loadInter();
                          }
                        } else {
                          _sliderKey.currentState.setPage(0);
                          setState(() {
                            next = "Next";
                            previous = "Quite";
                          });
                        }
                      },
                      text: next,
                      shape: GFButtonShape.pills,
                      size: GFSize.LARGE,
                      fullWidthButton: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
