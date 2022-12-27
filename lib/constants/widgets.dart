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
import 'package:flutter/foundation.dart';

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
    //           : AssetImage(assets/images/SoshiLogos/new_soshi_icon.png),
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
  double width;

  PassionBubble(this.passionString, this.passionEmoji, this.width);

  @override
  Widget build(BuildContext context) {
    print(width);
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
                  style: TextStyle(fontSize: width / 4),
                ),
              ),
              Container(
                //color: Colors.green,
                width: width,
                //child: Text(" "+ passionString,textAlign: TextAlign.center )
                child: AutoSizeText(
                  " " + passionString,
                  textAlign: TextAlign.center,
                  maxLines: 1, //passion.name.contains(" ") ? 2 : 1,
                  style: TextStyle(fontSize: width / 4),
                  minFontSize: 1,
                ),
              ),
            ],
          ),
        ));
  }
}

class SkillBubble extends StatelessWidget {
  String skillName;

  SkillBubble(this.skillName);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 5),
          child: Container(
            //color: Colors.green,
            width: width / 4,
            height: height / 40,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                skillName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: width / 30),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // child: AutoSizeText(
            //   skillName,
            //   textAlign: TextAlign.center,
            //   maxLines: 1, //passion.name.contains(" ") ? 2 : 1,
            //   style:
            //       TextStyle(fontSize: MediaQuery.of(context).size.width / 25),
            //   minFontSize: 10,
            // ),
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

class AddToContactsButtonNew extends StatelessWidget {
  String url;
  double width;
  AddToContactsButtonNew({required this.url, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Container(
        width: width / 1.3,
        child: NeumorphicButton(
            onPressed: () async {
              try {
                await URL.launchURL(url);
                // add contact added analytic here?
              } catch (e) {}
            },
            child: Text(
              "Add to Contacts",
              textAlign: TextAlign.center,
              style: TextStyle(letterSpacing: 1.4, fontSize: 20),
            ),
            style: NeumorphicStyle(
                shadowDarkColor: Colors.black,
                shadowLightColor: Colors.black12,
                color: Colors.blue,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(19.0)))),
      ),
    );
  }
}

class AddToContactsButton extends StatelessWidget {
  String url;
  double height, width;
  AddToContactsButton(
      {required this.url, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width / .9,
      child: NeumorphicButton(
          onPressed: () async {
            try {
              await URL.launchURL(url);
            } catch (e) {}
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    CupertinoIcons.cloud_download,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          style: NeumorphicStyle(
              shadowDarkColor: Colors.black12,
              shadowLightColor: Colors.black12,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(20.0)))
          // ElevatedButton.styleFrom(
          //   primary: Colors.black,
          //   elevation: 10,
          //   padding: const EdgeInsets.all(15.0),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(20.0),
          //   ),
          // ),
          ),
    );
  }
}

class SoshiUsernameText extends StatelessWidget {
  double fontSize;
  String username;
  bool isVerified;
  SoshiUsernameText(this.username,
      {required this.fontSize, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Text("@" + username,
            style: TextStyle(
              color: Colors.grey,
              fontSize: fontSize,
            )),
        Visibility(
          visible: isVerified != null && isVerified != false,
          child: Row(
            children: [
              SizedBox(
                width: fontSize / 10,
              ),
              Image.asset(
                "assets/images/misc/verified.png",
                width: fontSize,
                height: fontSize,
              ),
            ],
          ),
        )
      ],
    ));
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
      //splashColor: Colors.cyan[300],
      splashRadius: 1.0,
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
          if (platform == "Venmo") {
            await URL.launchVenmo(username);
          } else {
            URL.launchURL(
                URL.getPlatformURL(platform: platform, username: username));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
      iconSize: size,
    );
  }
}

class GetTheAppBanner extends StatelessWidget {
  double height, width;
  GetTheAppBanner(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "Download Soshi",
            //   style:
            //       TextStyle(fontWeight: FontWeight.bold, fontSize: width / 22),
            // ),
            // SizedBox(
            //   width: 15,
            // ),
            // Icon(CupertinoIcons.arrow_right_circle),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 3, 3),
              child: ElevatedButton(
                onPressed: () {
                  Analytics.logPressGetAppButton();
                  if (defaultTargetPlatform != TargetPlatform.android) {
                    // print("[+] Go to app store");
                    URL.launchURL(
                        "https://apps.apple.com/us/app/soshi/id1595515750?platform=iphone");
                  } else {
                    // print("[+] Go to play store");
                    URL.launchURL(
                        "https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                  }
                },
                child: Container(
                    //height: height / 2,
                    //width: width / 5,
                    child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Download Soshi  ",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      // SizedBox(width: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          "assets/images/SoshiLogos/new_soshi_icon.png",
                        ),
                      ),
                      // SizedBox(width: 10),
                      // Icon(
                      //   Icons.chevron_right,
                      //   size: 30,
                      // )
                    ],
                  ),
                )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  // side: BorderSide(color: Colors.cyan[400]!, width: 2),
                  //elevation: 15,
                  padding: const EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class CheckUsOutBanner extends StatelessWidget {
  double height, width;
  CheckUsOutBanner(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 3, 3),
              child: ElevatedButton(
                onPressed: () {
                  URL.launchURL("https://soshi.org");
                },
                child: Container(
                    //height: height / 2,
                    //width: width / 5,
                    child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Check us Out",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      // SizedBox(width: 15),

                      // SizedBox(width: 10),
                      // Icon(
                      //   Icons.chevron_right,
                      //   size: 30,
                      // )
                    ],
                  ),
                )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  // side: BorderSide(color: Colors.cyan[400]!, width: 2),
                  //elevation: 15,
                  padding: const EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
