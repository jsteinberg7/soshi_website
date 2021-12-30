import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

/* Widget to build the profile picture and check if they are null */
class ProfilePic extends StatelessWidget {
  double radius = 5;
  String url = "null";

  ProfilePic({required double radius, required String url}) {
    this.radius = radius;
    this.url = url;
  }

  @override
  Widget build(BuildContext context) {
    var backgroundImage;
    if (url != "null") {
      backgroundImage = NetworkImage(url);
    } else {
      backgroundImage = AssetImage('assets/images/SoshiLogos/soshi_icon.png');
    }

    return Container(
      child: CircleAvatar(
        radius: radius,
        backgroundImage: backgroundImage,
      ),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.cyanAccent,
          width: .5,
        ),
      ),
    );
  }
}
