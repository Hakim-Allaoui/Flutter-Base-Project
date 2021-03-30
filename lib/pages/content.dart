import 'package:baseproject/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ContentScreen extends StatefulWidget {
  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: Tools.width,
              height: 60.0,
              decoration: BoxDecoration(color: Colors.grey),
              child: Center(
                child: Text('Ad'),
              ),
            ),
            Expanded(
              child: Center(
                child: Text('Content'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: GFButton(
                      onPressed: () {},
                      text: "Previous",
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
                      onPressed: () {},
                      text: "Next",
                      shape: GFButtonShape.pills,
                      size: GFSize.LARGE,
                      fullWidthButton: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
