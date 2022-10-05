import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:soshi/analytics.dart';
import 'package:soshi/url.dart';

import '../../../constants/widgets.dart';

import 'package:glassmorphism/glassmorphism.dart';

import 'package:uuid/uuid.dart';

import 'database.dart';

class MobileView extends StatefulWidget {
  String friendSoshiUsername;
  double height;
  double width;

  MobileView(
      {required this.friendSoshiUsername, this.height = 0, this.width = 0});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  late String friendSoshiUsername;

  late DatabaseService databaseService;
  late double height;
  late double width;
  @override
  void initState() {
    super.initState();
    friendSoshiUsername = widget.friendSoshiUsername;
    databaseService = new DatabaseService(soshiUsernameIn: friendSoshiUsername);
    height = widget.height;
    width = widget.width;
    Analytics.logViewProfile();
  }

  Future<Map> getUserData() async {
    // add enabled platforms to map
    Analytics.setUserAttributes(userId: Uuid().toString());
    return await databaseService.getUserFile(friendSoshiUsername);
  }

  @override
  Widget build(BuildContext context) {
    double popupHeightDivisor;
    //double innerContainerSizeDivisor;
    if (height == 0) {
      height = MediaQuery.of(context).size.height;
    }
    if (width == 0) {
      width = MediaQuery.of(context).size.width;
    }
    return FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            dynamic userData = snapshot.data;
            String fullName = databaseService.getFullName(userData);
            String profilePhotoURL = databaseService.getPhotoURL(userData);
            String bio = databaseService.getBio(userData);
            bool isVerified = databaseService.getVerifiedStatus(userData);
            int soshiPoints = databaseService.getSoshiPoints(userData);
            int numfriends = userData["Friends"].length;
            String numFriendsString = numfriends.toString();
            String photoUrl = databaseService.getPhotoURL(userData);
            bool isContactEnabled;
            List<dynamic> passionsMap =
                databaseService.getPassions(userData) ?? [];
            print(passionsMap.toList());
            // List<Map> passionsMap = [
            //   {"passion_emoji": "😋", "passion_name": "food"},
            //   {"passion_emoji": "🏑", "passion_name": "hockey"},
            //   {"passion_emoji": "🏃‍♀️", "passion_name": "running"}
            // ];

            // List<Map> passionsMap = [];

            List<String> visiblePlatforms;
            Map usernames;

            // DYNAMIC SHARING if no friend data passed in
            visiblePlatforms =
                databaseService.getEnabledPlatformsList(userData);
            // get list of profile usernames
            usernames = databaseService.getUserProfileNames(userData);

            if (visiblePlatforms.contains("Contact")) {
              visiblePlatforms.remove("Contact");
              isContactEnabled = true;
            } else {
              isContactEnabled = false;
            }
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Stack(
                    children: [
                      ProfilePicBackdrop(photoUrl,
                          height: height / 2, width: width),
                      GlassmorphicContainer(
                        height: height / 2,
                        width: width,
                        borderRadius: 0,
                        blur: 10,
                        alignment: Alignment.bottomCenter,
                        border: 2,
                        linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              (Theme.of(context).brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(0.8),
                              (Theme.of(context).brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(0.4),
                            ],
                            stops: [
                              0.1,
                              1,
                            ]),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            (Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black)
                                .withOpacity(0.5),
                            (Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black)
                                .withOpacity(0.5),
                          ],
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(width / 40, 5, width / 40, 0),
                          child: Column(
                            children: [
                              SafeArea(
                                child: Column(
                                  children: [
                                    AutoSizeText(
                                      fullName,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: width / 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SoshiUsernameText(friendSoshiUsername,
                                            fontSize: width / 24,
                                            isVerified: isVerified)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 60,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: width / 4,
                                    child: Column(children: [
                                      Text(
                                        numFriendsString.toString(),
                                        style: TextStyle(
                                            fontSize: width / 25,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      numFriendsString == "1"
                                          ? Text(
                                              "Friend",
                                              style: TextStyle(
                                                  fontSize: width / 25,
                                                  letterSpacing: 1.2),
                                            )
                                          : Text(
                                              "Friends",
                                              style: TextStyle(
                                                  fontSize: width / 25,
                                                  letterSpacing: 1.2),
                                            )
                                    ]),
                                  ),
                                  Hero(
                                    tag: friendSoshiUsername,
                                    child: ProfilePic(
                                        radius: width / 6,
                                        url: profilePhotoURL),
                                    // child: Text(
                                    //   "c",
                                    //   textAlign: TextAlign.center,
                                    // )
                                  ),
                                  SizedBox(
                                    width: width / 4,
                                    child: Column(children: [
                                      Text(
                                        soshiPoints == null
                                            ? "0"
                                            : soshiPoints.toString(),
                                        style: TextStyle(
                                            fontSize: width / 25,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      soshiPoints.toString() == "1"
                                          ? Text("Bolt",
                                              style: TextStyle(
                                                  fontSize: width / 25,
                                                  letterSpacing: 1.2))
                                          : Text("Bolts",
                                              style: TextStyle(
                                                  fontSize: width / 25,
                                                  letterSpacing: 1.2))
                                    ]),
                                  ),
                                ],
                              ),
                              //SizedBox(height: height / 1),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      width / 6, height / 70, width / 6, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        child: //Padding(
                                            //padding: EdgeInsets.fromLTRB(width / 5, 0, width / 5, 0),
                                            //child:
                                            Visibility(
                                                visible: bio.isNotEmpty,
                                                child: Text(bio,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: width / 25
                                                        // color: Colors.grey[300],
                                                        )))),
                                  )
                                  //),
                                  ),
                              Visibility(
                                visible: !passionsMap.isEmpty,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height / 100),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: width / 65,
                                    children:
                                        List.generate(passionsMap.length, (i) {
                                      return PassionBubble(
                                          passionsMap[i]["passion_name"],
                                          passionsMap[i]["passion_emoji"],
                                          width / 5.5);
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: height / 2.05,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              width / 25, width / 30, 0, width / 30),
                          child: Row(
                            children: [
                              Text(
                                "Socials",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width / 18),
                              ),
                              Visibility(
                                  visible: isContactEnabled,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width / 2.5,
                                      ),
                                      AddToContactsButtonNew(
                                          url: usernames["Contact"],
                                          height: 20,
                                          width: width / 3),
                                      // IconButton(
                                      //     splashRadius: 1,
                                      //     iconSize: 10,
                                      //     onPressed: () {},
                                      //     icon: Icon(
                                      //         CupertinoIcons.person_add_solid)),
                                      // Container(
                                      //   height: 30,
                                      //   child: NeumorphicButton(
                                      //     style: NeumorphicStyle(
                                      //         color: Colors.blue),
                                      //     child: Row(
                                      //       children: [
                                      //         Text("Add to contacts"),
                                      //         // Icon(
                                      //         //     CupertinoIcons.cloud_download)
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Center(
                          child: (visiblePlatforms.isEmpty)
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                      "This user isn't currently sharing any social media platforms :(",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  // height: height / 3.5,
                                  width: width / 1.1,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: width / 40,
                                    children: List.generate(
                                        visiblePlatforms.length, (i) {
                                      return SMButton(
                                        soshiUsername: friendSoshiUsername,
                                        platform: visiblePlatforms[i],
                                        username:
                                            usernames[visiblePlatforms[i]],
                                        size: width / 7,
                                      );
                                    }),
                                  )),
                        ),
                        // SizedBox(
                        //   height: width / 40,
                        // ),
                        // Center(
                        //   child: Visibility(
                        //       visible: isContactEnabled,
                        //       // visible: false,
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: AddToContactsButton(
                        //           url: usernames["Contact"],
                        //           height: height / 30,
                        //           width: width / 2,
                        //         ),
                        //       )),
                        // ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 40,
                    child: GetTheAppBanner(height / 9, width)),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator.adaptive());
          }
        });
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
                          "assets/images/SoshiLogos/soshi_icon.png",
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
