import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../analytics.dart';
import '../database.dart';
import '../url.dart';
import 'constants.dart';

/* Widget to build the profile picture and check if they are null */
// /* Widget to build the profile picture and check if they are null */
class ProfilePic extends StatelessWidget {
  double radius;
  String url;

  ProfilePic({required this.radius, required this.url}) {
    this.radius = radius;
    this.url = url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        // border: new Border.all(
        //   color: Colors.cyanAccent,
        //   width: radius / 30,
        // ),
      ),
      child: CircularProfileAvatar(
        url,
        placeHolder: (b, c) {
          return Image.asset('assets/images/misc/default_pic.png');
        },
        borderColor: Colors.white,
        borderWidth: radius / 40,
        elevation: 0,
        radius: radius,
      ),
    );

    // String url = LocalDataService.getLocalProfilePictureURL();

    //   return Container(
    //     child: CircleAvatar(
    //       backgroundColor: Colors.cyan,
    //       radius: radius,
    //       backgroundImage: (url != null) && (url != "null")
    //           ? NetworkImage(url)
    //           : AssetImage('assets/images/SoshiLogos/soshi_icon.png'),
    //     ),
    //     decoration: new BoxDecoration(
    //       shape: BoxShape.circle,
    //       border: new Border.all(
    //         color: Colors.cyanAccent,
    //         width: .5,
    //       ),
    //     ),
    //   );
  }
}

class ProfilePicBackdrop extends StatelessWidget {
  String url;
  double height, width;

  ProfilePicBackdrop(this.url, {required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    if (url != null && url != "null") {
      return Image.network(
        url,
        fit: BoxFit.fill,
        height: height,
        width: width,
      );
    } else {
      return Image.asset("assets/images/misc/default_pic.png");
    }
  }
}

class PassionBubble extends StatelessWidget {
  String passionString;
  String passionEmoji;

  PassionBubble(this.passionString, this.passionEmoji);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  passionEmoji,
                  style: TextStyle(fontSize: width / 20),
                ),
              ),
              Container(
                //color: Colors.green,
                width: width / 5.5,
                child: AutoSizeText(
                  " " + passionString,
                  textAlign: TextAlign.center,
                  maxLines: 1, //passion.name.contains(" ") ? 2 : 1,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 25),
                  minFontSize: 1,
                ),
              ),
            ],
          ),
          // child: Container(
          //   width: width / 4.5,
          //   height: height / 30,
          //   decoration: BoxDecoration(color: Colors.blue),
          //   child: AutoSizeText(
          //     passionEmoji + passionString,
          //     // style: TextStyle(fontSize: width / 28),
          //   ),
          // ),
        ));
  }
}

class AddToContactsButton extends StatelessWidget {
  String url;
  double height, width;
  AddToContactsButton(
      {required this.url, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
        onPressed: () async {
          try {
            await URL.launchURL(url);
          } catch (e) {}
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
              height: height,
              width: width,
              child: Center(
                child: Container(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/images/SMLogos/ContactLogo.png",
                        height: 50,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Add To Contacts",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        CupertinoIcons.cloud_download,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              )),
        ),
        style: NeumorphicStyle(
            shadowDarkColor: Colors.black12,
            shadowLightColor: Colors.black12,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20.0)))
        // ElevatedButton.styleFrom(
        //   primary: Colors.black,
        //   elevation: 10,
        //   padding: const EdgeInsets.all(15.0),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20.0),
        //   ),
        // ),
        );
  }
}

class SMButton extends StatelessWidget {
  String soshiUsername, platform, username;
  double size;

  SMButton(
      {required this.soshiUsername,
      required this.platform,
      required this.username,
      this.size = 70.0});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // splashColor: Colors.cyan[300],
      splashRadius: 55.0,
      icon: Image.asset(
        "assets/images/SMLogos/" + platform + "Logo.png",
      ),
      onPressed: () async {
        Analytics.logAccessPlatform(platform);
        // if (platform == "Cryptowallet") {
        //   Clipboard.setData(ClipboardData(
        //     text: username.toString(),
        //   ));
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: const Text(
        //       'Wallet address copied to clipboard!',
        //       textAlign: TextAlign.center,
        //     ),
        //   ));
        // } else {
        // print("Launching $username");
        try {
          URL.launchURL(
              URL.getPlatformURL(platform: platform, username: username));
        } catch (e) {
          debugPrint(e.toString());
        }
      },
      iconSize: size,
    );
  }
}
