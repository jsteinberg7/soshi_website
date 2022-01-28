import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:soshi/database.dart';
import 'package:soshi/responsive.dart';
import 'package:soshi/url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/constants.dart';
import 'constants/widgets.dart';

class AnimatedGradient extends StatefulWidget {
  Widget child;

  AnimatedGradient({required this.child});
  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  List<Color> colorList = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
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
      decoration: BoxDecoration(gradient: LinearGradient(begin: begin, end: end, colors: [bottomColor, topColor])),
      child: widget.child,
    ));
  }
}

class SriUI3 extends StatefulWidget {
  String fullName;
  Map<String, dynamic> usernames;
  List<String> visiblePlatforms;
  String photoURL;
  String soshiUsername;
  String userBio;
  int friendsAdded;

  SriUI3(
      {required this.fullName,
      required this.usernames,
      required this.visiblePlatforms,
      required this.photoURL,
      required this.soshiUsername,
      required this.userBio,
      required this.friendsAdded});

  @override
  _SriUI3State createState() => _SriUI3State();
}

class _SriUI3State extends State<SriUI3> with TickerProviderStateMixin {
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
        await URL.launchURL(URL.getPlatformURL(platform: platform, username: username));
      },
      // iconSize: MediaQuery.of(context).size.width / 4,
      iconSize: 20,
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
      'Contact': {'contact_name': 'Contact', 'contact_icon': Icons.perm_contact_calendar_sharp}
    };

    usernamesCopy.keys.forEach((key) {
      if (visiblePlatforms.contains(key) == false) {
        return;
      }

      if (key == "Email" && widget.usernames[key] != null && widget.usernames[key] != "") {
        converter[key]['contact_info'] = widget.usernames[key];
        quickContacts.add(converter[key]);
        usernamesCopy['Email'] = null;
        // converter[key] = null;
      }

      if (key == "Phone" && widget.usernames[key] != null && widget.usernames[key] != "") {
        converter[key]['contact_info'] = widget.usernames[key];
        quickContacts.add(converter[key]);
        converter["SMS"]['contact_info'] = widget.usernames[key];
        quickContacts.add(converter["SMS"]);

        usernamesCopy['Phone'] = null;
        // converter[key] = null;
      }

      if (key == "Contact" && widget.usernames[key] != null && widget.usernames[key] != "") {
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
    print("total userName contacts after removing quick contacts: ${usernamesCopy.length}");
    print(widget.usernames);

    usernamesCopy.removeWhere((usernamesKey, usernamesValue) {
      if (usernamesValue == "" || usernamesValue == null) {
        return true;
      } else {
        return false;
      }
    });
// Remove all usernames that are now null

    print("total userName contacts after removing waste contacts: ${usernamesCopy.length}");
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
                                ),

                                SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    SizedBox(width: 10),
                                    Container(
                                      decoration:
                                          BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(20))),
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
                                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),

                                // vcfDownloadUrl != null && vcfDownloadUrl != ""
                                //     ? Card(
                                //         // color: Colors.black,
                                //         elevation: 10,
                                //         child: Container(
                                //           height: 40,
                                //           child: ElevatedButton.icon(
                                //             onPressed: () async {
                                //               print("Download .vcf file");

                                //               await launch(vcfDownloadUrl);
                                //             },
                                //             icon: Icon(Icons.perm_contact_calendar_rounded),
                                //             label: Text("Add to contacts"),
                                //             style: ElevatedButton.styleFrom(primary: Colors.cyan[300], onPrimary: Colors.black),
                                //           ),
                                //         ),
                                //       )
                                //     : Container(),

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
                            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width - 50 : MediaQuery.of(context).size.width - 500,
                            child: Scrollbar(
                              isAlwaysShown: true,
                              child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 1 / 1

                                      // maxCrossAxisExtent: 200, childAspectRatio: , crossAxisSpacing: 20, mainAxisSpacing: 20
                                      ),
                                  itemCount: usernamesCopy.keys.length,
                                  itemBuilder: (BuildContext context, index) {
                                    String currentKey = usernamesCopy.keys.elementAt(index);
                                    print("creating SM button");
                                    return Container(
                                        // height: 50,
                                        child: createSMButton(platform: currentKey, username: usernamesCopy[currentKey], context: context));
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
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: Column(
                    children: [
                      Text(
                        "Join Soshi to make your own!",
                        style: TextStyle(color: Colors.white, fontFamily: "Montserrat", fontSize: 15.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              URL.launchURL("https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                            },
                            child: Image.asset(
                              "assets/images/download_the_app/get_it_on_google_play.png",
                              width: 100,
                            ),
                          ),
                          SizedBox(width: 50),
                          GestureDetector(
                            onTap: () {
                              URL.launchURL("https://apps.apple.com/us/app/soshi/id1595515750");
                            },
                            child: Image.asset("assets/images/download_the_app/get_it_on_the_app_store.png", width: 100),
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
        decoration: ShapeDecoration.fromBoxDecoration(BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15.0))),
        child: Flex(direction: Axis.vertical, children: [
          Padding(
            padding: EdgeInsets.all(width / 40),
            child: Text(
              "Want your own contact card? Join the Soshi community today!",
              style: TextStyle(color: Colors.black, fontFamily: "Montserrat", fontSize: 15.0),
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
                      URL.launchURL("https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                    },
                    child: Image.asset(
                      "assets/images/download_the_app/get_it_on_google_play.png",
                      width: width / 3.5,
                    ),
                  ),
                  SizedBox(width: width / 20),
                  GestureDetector(
                    onTap: () {
                      URL.launchURL("https://apps.apple.com/us/app/soshi/id1595515750");
                    },
                    child: Image.asset("assets/images/download_the_app/get_it_on_the_app_store.png", width: width / 3.5),
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

        String url = URL.getPlatformURL(platform: contactData["contact_name"], username: contactData['contact_info']);

        await launch(url);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.1),
              // color: Colors.transparent,
              border: Border.all(
                color: Colors.black,
                width: 2,
              )),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                contactData['contact_icon'],
                color: Colors.black,
                size: 30,
              )),
        ),
      ),
    );
  }
}
