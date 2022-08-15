import 'package:flutter/material.dart';
import 'package:soshi/database.dart';
import 'package:soshi/url.dart';
import 'package:url_launcher/url_launcher.dart';

import 'analytics.dart';
import 'constants/constants.dart';
import 'constants/widgets.dart';

class SriUI2 extends StatefulWidget {
  String fullName;
  Map<String, dynamic> usernames;
  List<String> visiblePlatforms;
  String photoURL;
  String soshiUsername;
  String userBio;
  int friendsAdded;

  SriUI2(
      {required this.fullName,
      required this.usernames,
      required this.visiblePlatforms,
      required this.photoURL,
      required this.soshiUsername,
      required this.userBio,
      required this.friendsAdded});

  @override
  _SriUI2State createState() => _SriUI2State();
}

class _SriUI2State extends State<SriUI2> with TickerProviderStateMixin {
  String fullName = "";
  Map<String, dynamic> usernames = {};
  List<String> visiblePlatforms = [];
  String photoURL = "";

  List quickContacts = [];
  String vcfDownloadUrl = "";

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    this.fullName = widget.fullName;
    this.usernames = widget.usernames;
    this.visiblePlatforms = widget.visiblePlatforms;
    this.photoURL = widget.photoURL;
    _controller = AnimationController(
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  // Create a clickable social media icon
  static Widget createSMButton(

      // print("crate");
      {required String platform,
      required String username,
      required BuildContext context}) {
    return IconButton(
      splashColor: Colors.cyan[600],
      // splashRadius: 20,
      icon: Image.asset(
        "assets/images/SMLogos/" + platform + "Logo.png",
      ),
      onPressed: () async {
        // Analytics.logAccessPlatform(platform);
        await URL.launchURL(
            URL.getPlatformURL(platform: platform, username: username));
      },
      // iconSize: MediaQuery.of(context).size.width / 4,
      iconSize: 20,
    );
  }

  filterAllContacts() {
    print("total userName contacts Beginning : ${widget.usernames.length}");

    quickContacts = [];

    print("have username data: $usernames");

    Map converter = {
      'Phone': {
        'contact_name': 'Phone',
        'contact_icon': Icon(Icons.phone, size: 30, color: Colors.cyan[300])
      },
      'Email': {
        'contact_name': 'Email',
        'contact_icon': Icon(Icons.email, size: 30, color: Colors.cyan[300])
      },
      'SMS': {
        'contact_name': 'SMS',
        'contact_icon': Icon(Icons.chat, size: 30, color: Colors.cyan[300])
      }
    };

    widget.usernames.keys.forEach((key) {
      if (!visiblePlatforms.contains(key)) {
        return;
      }

      if (['Email', 'Phone'].contains(key) &&
          widget.usernames[key] != null &&
          widget.usernames[key] != "") {
        print("[+] User has a valid Phone # or Email for making Quick contact");

        converter[key]['contact_info'] = widget.usernames[key];

        quickContacts.add(converter[key]);

        if (key == "Phone") {
          converter["SMS"]['contact_info'] = widget.usernames[key];
          quickContacts.add(converter["SMS"]);
        }

        widget.usernames[key] = null;
      }
    });

    widget.usernames['Soshi'] = null;

    if (widget.visiblePlatforms.contains("Contact")) {
      vcfDownloadUrl = widget.usernames['Contact'];
    }

    widget.usernames['Contact'] = null;
    widget.usernames['Phone'] = null;

    print("total quick contacts: ${quickContacts.length}");
    print(
        "total userName contacts after removing quick contacts: ${widget.usernames.length}");
    print(widget.usernames);

    widget.usernames.removeWhere((usernamesKey, usernamesValue) {
      if (usernamesValue == "" || usernamesValue == null) {
        return true;
      } else {
        return false;
      }
    });

    print(
        "total userName contacts after removing waste contacts: ${widget.usernames.length}");
  }

  @override
  Widget build(BuildContext context) {
    filterAllContacts();

    MediaQueryData queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;
    int index = 0;

    return Container(
      decoration: BoxDecoration(gradient: Constants.greyCyanGradient),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Container(
                    alignment: Alignment.center,
                    child:

                        // Flex goes all the way to the end of scrollView
                        Column(mainAxisAlignment: MainAxisAlignment.start,
                            // direction: Axis.vertical,

                            children: [
                          // SizedBox(height: height / 65),
                          Container(
                            width: width / 1.05,
                            child: Container(
                              color: Colors.transparent,
                              child: Column(children: [
                                SizedBox(height: 5),

                                GestureDetector(
                                  onTap: () {
                                    URL.launchURL("https://www.soshi.org/");
                                  },
                                  child: Image.asset(
                                    "assets/images/SoshiLogos/soshi_logo.png",
                                    height: 30,
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Text(
                                  fullName,
                                  style: TextStyle(
                                    // color: Colors.cyan[300],
                                    color: Colors.black,
                                    // letterSpacing: 2,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 5),

                                Container(
                                  child: ProfilePic(radius: 50, url: photoURL),
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: Colors.cyanAccent,
                                      // color: Colors.black,
                                      width: 2.0,
                                    ),
                                  ),
                                ),

                                // SizedBox(width: width / 40),

                                SizedBox(height: 5),

                                Text(
                                  "@" + widget.soshiUsername,
                                  style: TextStyle(
                                      // color: Colors.cyan[300],
                                      color: Colors.black,
                                      letterSpacing: 2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(height: 5),
                                // AnimatedBuilder(
                                //   animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
                                //   builder: (context, child) {
                                //     return Align(
                                //       alignment: Alignment.center,
                                //       child: Container(
                                //         // decoration: fancyDecor,
                                //         height: 40,
                                //         // child: ElevatedButton.icon(
                                //         //   onPressed: () {},
                                //         //   icon: Icon(Icons.add),
                                //         //   label: Text("Add Friend"),
                                //         //   style: ElevatedButton.styleFrom(primary: Colors.cyan[300], onPrimary: Colors.black),
                                //         // ),
                                //         child: Row(
                                //           children: [Image.asset("assets/images/SoshiLogos/person_jump.gif")],
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),

                                vcfDownloadUrl != null && vcfDownloadUrl != ""
                                    ? Card(
                                        color: Colors.black,
                                        elevation: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            height: 40,
                                            child: ElevatedButton.icon(
                                              onPressed: () async {
                                                debugPrint(
                                                    "Download .vcf file");

                                                await launch(vcfDownloadUrl);
                                              },
                                              icon: Icon(Icons
                                                  .perm_contact_calendar_rounded),
                                              label: Text("Add to contacts"),
                                              style: ElevatedButton.styleFrom(
                                                  // primary: Colors.cyan[300],
                                                  onPrimary: Colors.black),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),

                                // Card(
                                //   elevation: 10,
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(1.0),
                                //     child: Container(
                                //       height: 40,
                                //       child: ElevatedButton.icon(
                                //         onPressed: () {
                                //           print("Open up the Soshi App on user Phone");
                                //         },
                                //         icon: Icon(Icons.add),
                                //         label: Text("Add Friend"),
                                //         style: ElevatedButton.styleFrom(primary: Colors.cyan[300], onPrimary: Colors.black),
                                //       ),
                                //     ),
                                //   ),
                                // ),

// {?} This is going to be the Bio
                                Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      child: Text(
                                        widget.userBio,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),

                          // SizedBox(height: 5),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: quickContacts.map((e) {
                                  return QuickContactSquare(contactData: e);
                                }).toList()),
                          ),
                          Divider(thickness: 1),
                          Container(
                            height: MediaQuery.of(context).size.height - 460,
                            width: MediaQuery.of(context).size.width - 50,
                            child: Scrollbar(
                              isAlwaysShown: true,
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1 / 1,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5
                                          // maxCrossAxisExtent: 200, childAspectRatio: 3 / 2, crossAxisSpacing: 20, mainAxisSpacing: 20
                                          ),
                                  itemCount: widget.usernames.keys.length,
                                  itemBuilder: (BuildContext context, index) {
                                    String currentKey =
                                        widget.usernames.keys.elementAt(index);
                                    print("creating SM button");
                                    return createSMButton(
                                        platform: currentKey,
                                        username: widget.usernames[currentKey],
                                        context: context);
                                  }),
                            ),
                          ),

// ------------- learn more Stuff

                          // GetYourOwnCard(height: height, width: width)
                        ])),
              ),
              Container(
                height: 65,
                // decoration: fancyDecor,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    // gradient: Constants.greyCyanGradient,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: Column(
                    children: [
                      Text(
                        "Join Soshi to make your own!",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  } //build

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(1 - _controller.value),
      ),
    );
  }
} // state variable

class GetYourOwnCard extends StatelessWidget {
  const GetYourOwnCard({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: height / 5,
        width: width / 2,
        decoration: ShapeDecoration.fromBoxDecoration(BoxDecoration(
            color: Colors.grey[50], borderRadius: BorderRadius.circular(15.0))),
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
    );
  }
}

class QuickContactSquare extends StatelessWidget {
  Map contactData;

  QuickContactSquare({required this.contactData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print("Contact button pressed");

        print(contactData);

        String url = URL.getPlatformURL(
            platform: contactData["contact_name"],
            username: contactData['contact_info']);

        await launch(url);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: contactData['contact_icon']),
        ),
      ),
    );
  }
}
