import 'package:baseproject/utils/tools.dart';
import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _stars = 0;

  Widget _buildStar(int starCount) {
    return InkWell(
      child: Icon(
        _stars >= starCount ? Icons.star : Icons.star_border,
        size: 30.0,
        color: _stars >= starCount ? Colors.orange : Colors.grey,
      ),
      onTap: () {
        print(starCount);
        if (starCount >= 4) {
          Navigator.pop(context);
          var url = 'https://play.google.com/store/apps/details?id=' +
              Tools.packageInfo.packageName;
          Tools.launchURL(url);
        }
        setState(() {
          _stars = starCount;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  child: Image.asset('assets/icon.png'),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Tools.packageInfo.appName,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'version ${Tools.packageInfo.version}(${Tools.packageInfo.buildNumber})',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ))
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "We need your support 🤗",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '👇 Please Rate App 👇',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStar(1),
          _buildStar(2),
          _buildStar(3),
          _buildStar(4),
          _buildStar(5),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'CANCEL',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .apply(color: Colors.black54),
          ),
          onPressed: () {
            Navigator.pop(context, 0);
          },
        ),
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .apply(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop(_stars);
          },
        )
      ],
    );
  }
}
