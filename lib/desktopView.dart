import 'package:flutter/material.dart';

import 'mobileView.dart';

class DesktopView extends StatelessWidget {
  String friendSoshiUsername;
  DesktopView({required this.friendSoshiUsername});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double phoneHeight = height / 1.25;
    double phoneWidth = phoneHeight / 2;
    return Scaffold(
        body: Center(
          child: Container(
            height: phoneHeight * 1.2,
            width: phoneHeight * 1.2,
            child: Stack(
              children: [
                Center(
                    child: Container(
                        height: phoneHeight,
                        width: phoneWidth,
                        child: Scaffold(
                          body: MobileView(
                            friendSoshiUsername: friendSoshiUsername,
                            height: phoneHeight,
                            width: phoneWidth,
                          ),
                        ))),
                IgnorePointer(
                  child: Center(
                      child: Container(
                          height: phoneHeight * 1.5,
                          width: phoneWidth * 1.3,
                          child: Image.asset(
                            "assets/images/misc/iphone.png",
                            fit: BoxFit.fill,
                          ))),
                ),
              ],
            ),
          ),
        ));
  }
}
