import 'package:flutter/material.dart';
import 'package:soshi/url.dart';

import 'constants/constants.dart';
import 'constants/widgets.dart';

class PageNotFoundScreen extends StatefulWidget {
  double height, width;
  PageNotFoundScreen(this.height, this.width, {bool launchURLIn = false});

  @override
  State<PageNotFoundScreen> createState() => _PageNotFoundScreenState();
}

class _PageNotFoundScreenState extends State<PageNotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    double height = widget.height;
    double width = widget.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          child: Text(
            "The user you're looking for could not be found :(",
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, height / 3.5, 0, height / 40),
          child: Column(
            children: [
              CheckUsOutBanner(height / 9, width),
              GetTheAppBanner(height / 9, width),
            ],
          ),
        ),
      ],
    );
  }
}
