import 'package:flutter/material.dart';
import 'package:soshi/database.dart';
import 'package:soshi/url.dart';

import 'constants/constants.dart';
import 'constants/widgets.dart';

class UserInfoDisplay extends StatefulWidget {
  String fullName = "";
  Map<String, dynamic> usernames = {};
  List<String> visiblePlatforms = [];
  String photoURL = "";

  UserInfoDisplay(
      {required String fullName,
      required Map<String, dynamic> usernames,
      required List<String> visiblePlatforms,
      required String photoURL}) {
    this.fullName = fullName;
    this.usernames = usernames;
    this.visiblePlatforms = visiblePlatforms;
    this.photoURL = photoURL;
  }

  @override
  _UserInfoDisplayState createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {
  String fullName = "";
  Map<String, dynamic> usernames = {};
  List<String> visiblePlatforms = [];
  String photoURL = "";

  @override
  void initState() {
    super.initState();
    this.fullName = widget.fullName;
    this.usernames = widget.usernames;
    this.visiblePlatforms = widget.visiblePlatforms;
    this.photoURL = widget.photoURL;
  }

  // Create a clickable social media icon
  static Widget createSMButton(

    // print("crate");
      {required String platform,
      required String username,
      required BuildContext context}) {
    return IconButton(
      splashColor: Colors.cyan[600],
      splashRadius: 55.0,
      icon: Image.asset(
        "assets/images/SMLogos/" + platform + "Logo.png",
      ),
      onPressed: () async {
        // if (platform == "Phone") {
        //   // DatabaseService.downloadVCard(otherUID);
        // } else
        // {
        await URL.launchURL(
            URL.getPlatformURL(platform: platform, username: username));
        // }
      },
      iconSize: MediaQuery.of(context).size.width / 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;
    int index = 0;
    return Container(
      decoration: BoxDecoration(gradient: Constants.greyCyanGradient),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Flex(direction: Axis.vertical, children: [
                  SizedBox(height: height / 65),
                  Container(
                    width: width / 1.05,
                    child: Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.cyanAccent)),
                      color: Constants.buttonColorDark,
                      child: Padding(
                        padding: EdgeInsets.all(width / 30),
                        child: Flex(direction: Axis.horizontal, children: [
                          Container(
                            child: ProfilePic(radius: 50, url: photoURL),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.cyanAccent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          SizedBox(width: width / 40),
                          Column(children: [
                            Text(
                              fullName,
                              style: TextStyle(
                                color: Colors.cyan[300],
                                letterSpacing: 2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height / 100,
                            ),
                            Text(
                              "@" + usernames["Soshi"],
                              style: TextStyle(
                                  color: Colors.cyan[300],
                                  letterSpacing: 2,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ]),
                        ]),
                      ),
                    ),
                  ),
                  Divider(color: Colors.cyan[300]),
                  Padding(padding: EdgeInsets.only(top: height / 50)),
                  Container(
                    decoration: BoxDecoration(
                      color: Constants.buttonColorDark,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.cyanAccent),
                    ),
                    height: (height / 5) * (visiblePlatforms.length / 3).ceil(),
                    width: width / 1.10,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int i) {
                        return Padding(padding: EdgeInsets.all(5.0));
                      },
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int i) {
                        return Flex(direction: Axis.horizontal, children: [
                          // SizedBox(width: width / 5),
                          createSMButton(
                              platform: visiblePlatforms[index],
                              username: usernames[visiblePlatforms[index++]],
                              context: context),
                          (index >= visiblePlatforms.length)
                              ? Text("")
                              : createSMButton(
                                  platform: visiblePlatforms[index],
                                  username:
                                      usernames[visiblePlatforms[index++]],
                                  context: context),
                          (index >= visiblePlatforms.length)
                              ? Text("")
                              : createSMButton(
                                  platform: visiblePlatforms[index],
                                  username:
                                      usernames[visiblePlatforms[index++]],
                                  context: context),
                        ]);
                      },
                      itemCount: (visiblePlatforms.length / 3).ceil(),
                    ),
                  ),
                  SizedBox(height: height / 45),
                  GestureDetector(
                    onTap: () {
                      URL.launchURL("https://www.soshi.org/");
                    },
                    child: Image.asset(
                      "assets/images/SoshiLogos/soshi_logo.png",
                      height: height / 20,
                    ),
                  ),
                  Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      height: height / 5,
                      width: width / 2,
                      decoration: ShapeDecoration.fromBoxDecoration(
                          BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15.0))),
                      child: Flex(direction: Axis.vertical, children: [
                        Padding(
                          padding: EdgeInsets.all(width / 40),
                          child: Text(
                            "Want your own contact card? Join the Soshi community today!",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 15.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                        Container(
                          height: height / 14,
                          child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    URL.launchURL(
                                        "https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                                  },
                                  child: Image.asset(
                                    "assets/images/download_the_app/get_it_on_google_play.png",
                                    width: width / 3.5,
                                  ),
                                ),
                                SizedBox(width: width / 20),
                                GestureDetector(
                                  onTap: () {
                                    URL.launchURL(
                                        "https://apps.apple.com/us/app/soshi/id1595515750");
                                  },
                                  child: Image.asset(
                                      "assets/images/download_the_app/get_it_on_the_app_store.png",
                                      width: width / 3.5),
                                ),
                                // ),
                              ]),
                        )
                      ]),
                    ),
                  )
                ])),
          )),
    );
  }
}
