import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'constants.dart';

/* Widget to build the profile picture and check if they are null */
class ProfilePic extends StatelessWidget {
  double radius = 10.0;
  String url = "";

  ProfilePic({required double radius, required String url}) {
    this.radius = radius;
    this.url = url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.cyanAccent,
          width: radius / 30,
        ),
      ),
      child: CircularProfileAvatar(
        url,
        placeHolder: (b, c) {
          return Image.asset('assets/images/SoshiLogos/soshi_icon.png');
        },
        borderColor: Colors.black,
        borderWidth: radius / 20,
        elevation: 5,
        radius: radius,
      ),
    );
  }
}
