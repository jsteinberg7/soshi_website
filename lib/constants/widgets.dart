import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'constants.dart';

/* Widget to build the profile picture and check if they are null */
class ProfilePic extends StatelessWidget {
  double customSize = 10.0;
  String url = "";

  ProfilePic({required double radius, required String url}) {
    this.customSize = radius;
    this.url = url;

    print("received url +" + url.toString());
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: new BoxDecoration(
    //     shape: BoxShape.circle,
    //     border: new Border.all(
    //       color: Colors.cyanAccent,
    //       width: radius / 30,
    //     ),
    //   ),

    //   // child: CircleAvatar(foregroundImage: AssetImage("assets/images/SoshiLogos/soshi_icon.png"), radius: radius),
    //   child: url == "null" || url == null || url == ""
    //       ? CircleAvatar(foregroundImage: AssetImage("assets/images/SoshiLogos/soshi_icon.png"), radius: radius)
    //       : CircularProfileAvatar(
    //           url,
    //           placeHolder: (b, c) {
    //             return Image.asset('assets/images/SoshiLogos/soshi_icon.png');
    //           },
    //           borderColor: Colors.black,
    //           borderWidth: radius / 20,
    //           elevation: 5,
    //           radius: radius,
    //         ),
    // );

    // return Image.asset('assets/images/SoshiLogos/soshi_icon.png', height: 50);

    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            // height: 110,
            // width: 110,
            height: customSize,
            width: customSize,
            child: url == "null" || url == null || url == ""
                ? Image.asset(
                    'assets/images/SoshiLogos/soshi_icon.png',
                    height: customSize,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    url,
                    height: customSize,
                    fit: BoxFit.cover,
                  )),
      ),
    );
  }
}
