import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soshi/database.dart';
import 'package:soshi/url.dart';

import 'constants/constants.dart';
import 'constants/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io' show Platform;

class UserInfoDisplay extends StatefulWidget {
  String fullName;
  Map<String, dynamic> usernames;
  List<String> visiblePlatforms;
  String photoURL;
  String bio;
  int friendsAdded;
  Map platformMetaData;

  UserInfoDisplay({
    required this.fullName,
    required this.usernames,
    required this.visiblePlatforms,
    required this.photoURL,
    required this.bio,
    required this.friendsAdded,
    required this.platformMetaData});

  @override
  _UserInfoDisplayState createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {

  @override
  void initState() {
    print("init State");
    print(widget.platformMetaData);
    super.initState();
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
        await URL.launchURL(URL.getPlatformURL(platform: platform, username: username));
        // }
      },
      iconSize: MediaQuery.of(context).size.width / 4,
    );
  }

  showMetaDataHidden(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hidden metaData (debug)"),
      content: Text(widget.platformMetaData.toString()),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.platformMetaData);

    MediaQueryData queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;
    List nameSplit = widget.fullName.split(" ");
    String firstName = nameSplit[0];
    String lastName = nameSplit[1];
    int index = 0;
    return Container(
      decoration: BoxDecoration(gradient: Constants.greyCyanGradient),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Column(children: [
                  // SizedBox(height: height / 65),
                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      URL.launchURL("https://www.soshi.org/");
                    },
                    child: Image.asset(
                      "assets/images/SoshiLogos/soshi_logo.png",
                      height: height / 20,
                    ),
                  ),

                  // Divider(
                  //   thickness: 1,
                  //   color: Colors.grey,
                  // ),
                  SizedBox(height: 10),

                  Container(
                    width: width / 1.05,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.cyanAccent)),
                      color: Constants.buttonColorDark,
                      child: Padding(
                        padding: EdgeInsets.all(width / 30),
                        child: Flex(direction: Axis.vertical, children: [
                          Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: ProfilePic(url: widget.photoURL, radius: height / 13),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 25),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: width / 2.5,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Colors.transparent, width: 1.0)),
                                          child: Text(
                                            widget.fullName,
                                            style: TextStyle(fontSize: width / 15, fontWeight: FontWeight.bold, color: Colors.grey[200]),
                                          ),
                                        ),

                                        // Text(
                                        //   firstName,
                                        //   style: TextStyle(
                                        //       fontSize: width / 15,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: Colors.grey[200]),
                                        // ),
                                        // Text(
                                        //   lastName,
                                        //   style: TextStyle(
                                        //       fontSize: width / 15,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: Colors.grey[200]),
                                        // ),
                                        SizedBox(height: height / 110),
                                        Column(
                                          children: [
                                            Text(
                                              "@" + widget.usernames["Soshi"],
                                              style: TextStyle(fontSize: width / 20, color: Colors.grey[500], fontStyle: FontStyle.italic),
                                            ),
                                            SizedBox(height: height / 70),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.emoji_people,
                                                  color: Colors.cyan,
                                                  size: width / 15,
                                                ),
                                                SizedBox(width: 3),
                                                Text(
                                                  "Friends: " + widget.friendsAdded.toString(),
                                                  style: TextStyle(fontSize: width / 20, color: Colors.grey[500], fontStyle: FontStyle.italic),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(width / 50, width / 50, width / 50, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Colors.transparent, width: 0.0)),
                                  //height: height / 20,
                                  width: width,

                                  child: Center(
                                      child:
                                          (widget.bio != null) ? Text(widget.bio, style: TextStyle(color: Colors.grey[300], fontSize: width / 18)) : Container()),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: height / 80)),
                  Container(
                    decoration: BoxDecoration(
                      color: Constants.buttonColorDark,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.cyanAccent),
                    ),
                    height: (height / 5.4) * (widget.visiblePlatforms.length / 3).ceil(),
                    width: width / 1.07,
                    child: Center(
                      child: (widget.visiblePlatforms.length > 0)
                          ? GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // padding: EdgeInsetsGeometry.infinity,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int i) {
                                return createSMButton(platform: widget.visiblePlatforms[i], username: widget.usernames[widget.visiblePlatforms[i]], context: context);
                              },
                              itemCount: widget.visiblePlatforms.length,
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "This user isn't currently sharing any social media platforms :(",
                                  style: Constants.CustomCyan,
                                ),
                              ),
                            ),
                    ),
                  ),
                  // SizedBox(height: height / 190),
                  SizedBox(height: 20),

                  // Banner1(),

                  Container(
                    child: Card(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 300,
                            height: 80,
                            child: Row(
                              children: [
                                Card(
                                  elevation: 7,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: InkWell(
                                    onLongPress: () {
                                      print("print metadata now!");
                                      showMetaDataHidden(context);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      child: Image.asset(
                                        'assets/images/SoshiLogos/soshi_icon.png',
                                        height: 75,
                                        width: 75,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                  children: [
                                    Text(
                                      "Want your own?",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    widget.platformMetaData['appVersion'].toString().contains("iPhone")
                                        ? InkWell(
                                            onTap: () {
                                              print("[+] Go to app store");
                                              URL.launchURL("https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                                            },
                                            child: Image.asset("assets/images/download_the_app/get_it_on_the_app_store.png", width: 120))
                                        : widget.platformMetaData['appVersion'].toString().contains("Android")
                                            ? InkWell(
                                                onTap: () {
                                                  URL.launchURL("https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                                                },
                                                child: Image.asset(
                                                  "assets/images/download_the_app/get_it_on_google_play.png",
                                                  width: 120,
                                                ),
                                              )
                                            : Container(
                                                height: 40,
                                                child: ElevatedButton.icon(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.cyanAccent,
                                                        onPrimary: Colors.black,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                                    onPressed: () {
                                                      print("get url");
                                                      // if (Platform.isIOS) {
                                                      //   print("[+] Go to app store");
                                                      //   URL.launchURL(
                                                      //       "https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                                                      // } else {
                                                      //   print("[+] Go to play store");
                                                      //   URL.launchURL(
                                                      //       "https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                                                      // }

                                                      URL.launchURL("https://www.soshi.org");
                                                    },
                                                    icon: Icon(Icons.insert_link_rounded),
                                                    label: Text(
                                                      "Learn more",
                                                    )),
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),

                  SizedBox(
                    height: height / 20,
                  )
                ])),
          )),
    );
  }
}

class Banner1 extends StatelessWidget {
  const Banner1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          color: Colors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 250,
              height: 50,
              child: Row(
                children: [
                  Text(
                    "Want your own?",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: 40,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.cyanAccent,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                        onPressed: () {
                          if (Platform.isIOS) {
                            print("[+] Go to app store");
                            URL.launchURL("https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                          } else {
                            print("[+] Go to play store");
                            URL.launchURL("https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                          }
                        },
                        icon: Icon(Icons.download),
                        label: Text(
                          "Get",
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
