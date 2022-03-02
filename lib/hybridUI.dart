import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:soshi/database.dart';
import 'package:soshi/responsive.dart';
import 'package:soshi/url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/constants.dart';
import 'constants/widgets.dart';

bool biz = true;

class AnimatedGradient extends StatefulWidget {
  Widget child;

  AnimatedGradient({required this.child});
  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.red;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        bottomColor = Colors.blue;
      });
    });

    return Scaffold(
        body: AnimatedContainer(
      duration: Duration(seconds: 2),
      onEnd: () {
        setState(() {
          index = index + 1;
          // animate the color
          bottomColor = colorList[index % colorList.length];
          topColor = colorList[(index + 1) % colorList.length];
          //// animate the alignment
          begin = alignmentList[index % alignmentList.length];
          end = alignmentList[(index + 2) % alignmentList.length];
        });
      },
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: begin, end: end, colors: [bottomColor, topColor])),
      child: widget.child,
    ));
  }
}

class SriUI4 extends StatefulWidget {
  String fullName;
  Map<String, dynamic> usernames;
  List<String> visiblePlatforms;
  String photoURL;
  String soshiUsername;
  String userBio;
  int friendsAdded;
  bool isVerified;

  SriUI4(
      {required this.fullName,
      required this.usernames,
      required this.visiblePlatforms,
      required this.photoURL,
      required this.soshiUsername,
      required this.userBio,
      required this.friendsAdded,
      required this.isVerified});

  @override
  _SriUI4State createState() => _SriUI4State();
}

class _SriUI4State extends State<SriUI4> with TickerProviderStateMixin {
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
  }

  createWebsite() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            // "https://icons-for-free.com/download-icon-high+quality+social+social+media+square+website+www+icon-1320192619856305568_32.png",
            // "https://st2.depositphotos.com/4202565/9540/v/950/depositphotos_95408772-stock-illustration-white-website-icon.jpg",
            // "https://ak.picdn.net/shutterstock/videos/1057666969/thumb/7.jpg?ip=x480",
            "https://ak.picdn.net/shutterstock/videos/1056117800/thumb/4.jpg",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  static Widget createMenue() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            // "https://images.squarespace-cdn.com/content/v1/5c724434fb1820401d01c3c6/1550993794454-I1C4EX0XC2FZM77JKD5V/menu+icon+big.png",
            // "https://thumbs.dreamstime.com/b/restaurant-menu-vector-flat-color-line-icon-restaurant-menu-icon-website-design-desktop-envelopment-development-premium-166585029.jpg",
            // "https://media.istockphoto.com/vectors/restaurant-food-menu-icon-black-vector-design-is-isolated-on-a-white-vector-id1268954466",
            "https://cdn-icons-png.flaticon.com/512/1046/1046747.png",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
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
        await URL.launchURL(
            URL.getPlatformURL(platform: platform, username: username));
      },
      // iconSize: MediaQuery.of(context).size.width / 4,
      iconSize: 50,
    );
  }

  Map<String, dynamic> usernamesCopy = {};

  filterAllContacts() {
    print("total userName contacts Beginning : ${widget.usernames.length}");

    quickContacts = [];

    print("have username data: $usernames");

    usernamesCopy = Map.of(widget.usernames);

    Map converter = {
      'Phone': {'contact_name': 'Phone', 'contact_icon': Icons.phone},
      'Email': {'contact_name': 'Email', 'contact_icon': Icons.email},
      'SMS': {'contact_name': 'SMS', 'contact_icon': Icons.chat},
      'Contact': {
        'contact_name': 'Contact',
        'contact_icon': Icons.perm_contact_calendar_sharp
      }
    };

    usernamesCopy.keys.forEach((key) {
      if (visiblePlatforms.contains(key) == false) {
        usernamesCopy[key] = null;
        return;
      }

      if (key == "Email" &&
          widget.usernames[key] != null &&
          widget.usernames[key] != "") {
        converter[key]['contact_info'] = widget.usernames[key];
        quickContacts.add(converter[key]);
        usernamesCopy['Email'] = null;
        // converter[key] = null;
      }

      if (key == "Phone" &&
          widget.usernames[key] != null &&
          widget.usernames[key] != "") {
        converter[key]['contact_info'] = widget.usernames[key];
        quickContacts.add(converter[key]);
        converter["SMS"]['contact_info'] = widget.usernames[key];
        quickContacts.add(converter["SMS"]);

        usernamesCopy['Phone'] = null;
        // converter[key] = null;
      }

      if (key == "Contact" &&
          widget.usernames[key] != null &&
          widget.usernames[key] != "") {
        vcfDownloadUrl = widget.usernames['Contact'];
        converter["Contact"]['contact_info'] = vcfDownloadUrl;
        quickContacts.add(converter["Contact"]);
        usernamesCopy['Contact'] = null;
        // converter[key] = null;
      }
    }); // FOREACH ENDING

    // These platform are encoded to "Quick Actions" so remove them
    usernamesCopy['Soshi'] = null;

    print("total quick contacts: ${quickContacts.length}");
    print(
        "total userName contacts after removing quick contacts: ${usernamesCopy.length}");
    print(widget.usernames);

    // Clean up
    usernamesCopy.removeWhere((usernamesKey, usernamesValue) {
      if (usernamesValue == "" || usernamesValue == null) {
        return true;
      } else {
        return false;
      }
    });
// Remove all usernames that are now null

    print(
        "total userName contacts after removing waste contacts: ${usernamesCopy.length}");

    usernamesCopy['Menu'] = "DUMMY_MENU";

    usernamesCopy['Website'] = "WEBSITE";
  }

  @override
  Widget build(BuildContext context) {
    print("[+] rebuilding entire screen");
    filterAllContacts();

    MediaQueryData queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;
    int index = 0;

    return Container(
      // decoration: BoxDecoration(gradient: Constants.greyCyanGradient),

      child: Scaffold(
          // bottomNavigationBar: DownloadSoshiBanner(),
          bottomNavigationBar: GetYourOwnCard(),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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

                            Container(
                              child: Card(
                                color: Colors.white.withOpacity(0.6),
                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      child: ProfilePic(
                                          radius: 120, url: photoURL),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Text(
                                          fullName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
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
                                            SizedBox(width: 5),
                                            true
                                                ? Icon(Icons.verified,
                                                    color: Colors.blue)
                                                : Container(),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.emoji_people,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "${widget.friendsAdded} Friends",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 5),

                            // {?} This is going to be the Bio
                            Container(
                              width: MediaQuery.of(context).size.width - 10,
                              // height: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  child: Text(
                                    widget.userBio,
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    // softWrap: false,
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),

                      // SizedBox(height: 5),
                      Divider(thickness: 1),
                      Card(
                        elevation: 7,
                        color: Colors.white.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.black38,

                              // gradient: Constants.greyCyanGradient,
                              // border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          width: MediaQuery.of(context).size.width - 20,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: quickContacts.map((e) {
                                return QuickContactSquare(contactData: e);
                              }).toList()),
                        ),
                      ),
                      Divider(thickness: 1),
                      Container(
                        // color: Colors.red,
                        // height: MediaQuery.of(context).size.height - 460,
                        // height: double.infinity,
                        width: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width - 50
                            : MediaQuery.of(context).size.width - 500,
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              // childAspectRatio: 1 / 1

                              // maxCrossAxisExtent: 200, childAspectRatio: , crossAxisSpacing: 20, mainAxisSpacing: 20
                            ),
                            itemCount: usernamesCopy.keys.length,
                            itemBuilder: (BuildContext context, index) {
                              String currentKey =
                                  usernamesCopy.keys.elementAt(index);
                              print("creating SM button");

                              if (currentKey == "Menu") {
                                return createMenue();
                              } else if (currentKey == "Website") {
                                return createWebsite();
                              }
                              return Container(
                                  // height: 50,
                                  child: createSMButton(
                                      platform: currentKey,
                                      username: usernamesCopy[currentKey],
                                      context: context));
                            }),
                      ),

// ------------- learn more Stuff

                      // GetYourOwnCard(height: height, width: width)

                      Divider(thickness: 1),
                      SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          print("send feedback pressed [!]");
                          showModalBottomSheet<void>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 320,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("Feedback",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.blueGrey)),
                                      ),
                                      RatingBar.builder(
                                        itemSize: 60,
                                        initialRating: 3,
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          switch (index) {
                                            case 0:
                                              return Icon(
                                                Icons
                                                    .sentiment_very_dissatisfied,
                                                color: Colors.red,
                                              );
                                            case 1:
                                              return Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.redAccent,
                                              );
                                            case 2:
                                              return Icon(
                                                Icons.sentiment_neutral,
                                                color: Colors.amber,
                                              );
                                            case 3:
                                              return Icon(
                                                Icons.sentiment_satisfied,
                                                color: Colors.lightGreen,
                                              );
                                            case 4:
                                              return Icon(
                                                Icons.sentiment_very_satisfied,
                                                color: Colors.green,
                                              );
                                          }

                                          return Icon(Icons.cancel);
                                        },
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          height: 120,
                                          child: TextField(
                                            maxLines: null,
                                            maxLength: 120,
                                            maxLengthEnforced: true,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              hintText: "Type your feedback...",
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print(
                                              "SUBMIT GIVEN FEEDBACK to business!");
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 7,
                                          child: Container(
                                            height: 40,
                                            width: 200,
                                            // decoration: fancyDecor,
                                            decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.4),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),

                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.send_rounded,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                                SizedBox(width: 10),
                                                Text("Submit",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 7,
                          child: Container(
                            height: 60,
                            width: 250,
                            // decoration: fancyDecor,
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(width: 10),
                                Text("Send Feedback",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ],
                            ),

                            // child: ElevatedButton.icon(
                            //     onPressed: () {},
                            //     icon: Icon(Icons.chat_bubble),
                            //     label: Text("Send Feedback", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                    ]),
                // DownloadSoshiBanner()
              ],
            ),
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
}

class DownloadSoshiBanner extends StatelessWidget {
  const DownloadSoshiBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      // decoration: fancyDecor,
      decoration: BoxDecoration(
          color: Colors.black38,
          // gradient: Constants.greyCyanGradient,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 5, 2, 0),
        child: Column(
          children: [
            Text(
              "Join Soshi to make your own!",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
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
                    width: 150,
                  ),
                ),
                SizedBox(width: 50),
                GestureDetector(
                  onTap: () {
                    URL.launchURL(
                        "https://apps.apple.com/us/app/soshi/id1595515750");
                  },
                  child: Image.asset(
                      "assets/images/download_the_app/get_it_on_the_app_store.png",
                      width: 150),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} // state variable

class GetYourOwnCard extends StatelessWidget {
  const GetYourOwnCard({
    Key? key,
    // required this.height,
    // required this.width,
  }) : super(key: key);

  // final double height;
  // final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Card(
        elevation: 10,
        // shape: ShapeBorder(borderRadius: BorderRadius.circular(15.0))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          // height: height / 5,
          // width: width / 2,
          height: 140,
          width: 150,
          decoration: ShapeDecoration.fromBoxDecoration(BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15.0))),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Want your own contact card? Join the Soshi community today!",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: () {
                  URL.launchURL(
                      "https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                },
                child: Image.asset(
                  "assets/images/download_the_app/get_it_on_google_play.png",
                  height: 40,
                  // width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                  onTap: () {
                    URL.launchURL(
                        "https://apps.apple.com/us/app/soshi/id1595515750");
                  },
                  child: Image.asset(
                    "assets/images/download_the_app/get_it_on_the_app_store.png",
                    height: 40,
                    // width: 120,
                    fit: BoxFit.cover,
                  )),
              // ),
            ])
          ]),
        ),
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
          height: 60,
          width: 60,
          // decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.black.withOpacity(0.1),
          //     // color: Colors.transparent,
          //     border: Border.all(
          //       color: Colors.black,
          //       width: 2,
          //     )),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            // child: Icon(
            //   contactData['contact_icon'],
            //   color: Colors.black,
            //   size: 30,
            // )

            child: Container(
              child: Image.asset(
                "assets/images/SMLogos/" +
                    contactData['contact_name'] +
                    "Logo.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
