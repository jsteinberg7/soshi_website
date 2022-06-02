import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:soshi/database.dart';
import 'package:soshi/responsive.dart';
import 'package:soshi/url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/constants.dart';
import 'constants/widgets.dart';
import 'package:flutter/foundation.dart';

bool biz = true;

class AnimatedGradient extends StatefulWidget {
  Widget child;

  AnimatedGradient({required this.child});
  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  List<Color> colorList = [
    // Colors.red,
    // Colors.blue,
    // Colors.green,
    // Colors.yellow
    Colors.black,
    Colors.cyan[100]!,
    // Colors.cyan[500]!,
    Colors.cyan[900]!,
    Colors.white
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.black;
  Color topColor = Colors.white;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        bottomColor = Colors.cyan;
      });
    });

    return Scaffold(
        body: AnimatedContainer(
      duration: Duration(seconds: 5),
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
          gradient: LinearGradient(begin: begin, end: end, colors: [bottomColor, topColor])),
      child: widget.child,
    ));
  }
}

class HybridUI extends StatefulWidget {
  String fullName;
  Map<String, dynamic> usernames;
  List<String> visiblePlatforms;
  String photoURL;
  String soshiUsername;
  String userBio;
  int friendsAdded;
  bool isVerified;
  bool isBusiness;

  HybridUI(
      {required this.fullName,
      required this.usernames,
      required this.visiblePlatforms,
      required this.photoURL,
      required this.soshiUsername,
      required this.userBio,
      required this.friendsAdded,
      required this.isVerified,
      required this.isBusiness});

  @override
  _HybridUIState createState() => _HybridUIState();
}

class _HybridUIState extends State<HybridUI> with TickerProviderStateMixin {
  String fullName = "";
  Map<String, dynamic> usernames = {};
  List<String> visiblePlatforms = [];
  String photoURL = "";
  bool isContactEnabled = false;
  List quickContacts = [];
  String vcfDownloadUrl = "";

  late AnimationController _controller;
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 10.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    this.fullName = widget.fullName;
    this.usernames = widget.usernames;
    this.visiblePlatforms = widget.visiblePlatforms;
    if (visiblePlatforms.contains("Contact")) {
      visiblePlatforms.remove("Contact");
      isContactEnabled = true;
    }
    this.photoURL = widget.photoURL;

    super.initState();
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
        if (platform == "Venmo") {
          await URL.launchVenmo(username);
        } else {
          await URL.launchURL(URL.getPlatformURL(platform: platform, username: username));
        }
      },
      // iconSize: MediaQuery.of(context).size.width / 4,
      iconSize: 50,
    );
  }

  Map<String, dynamic> usernamesCopy = {};

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;
    int index = 0;

// NEW RESPONSIVE
    return Responsive.isDesktop(context)
        ? Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        URL.launchURL("https://www.soshi.org/");
                      },
                      child: Image.asset(
                        "assets/images/SoshiLogos/soshi_logo.png",
                        height: 50,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 900,
                      height: 700,
                      decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          // color: Color.fromARGB(255, 27, 28, 30),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.cyan.withOpacity(0.8),
                                blurRadius: _animation.value,
                                spreadRadius: _animation.value)
                          ]),
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      child: Image.network(
                                        // "https://qph.cf2.quoracdn.net/main-qimg-142be607dd44672c4cf844cda26962a3-lq",
                                        photoURL,
                                        height: 700,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 80, 20, 10),
                                        child: Text(
                                          fullName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 50,
                                              fontWeight: FontWeight.w200,
                                              fontFamily: "Arial"),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "@" + widget.soshiUsername,
                                            style: TextStyle(
                                                // color: Colors.cyan[300],
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                fontFamily: "Arial"),
                                          ),
                                          SizedBox(width: 5),
                                          widget.isVerified
                                              ? Icon(Icons.verified, color: Colors.blue)
                                              : Container(),
                                          SizedBox(width: 10),
                                          Container(
                                              height: 50,
                                              child: VerticalDivider(color: Colors.grey)),
                                          SizedBox(width: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.emoji_people,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              Text(
                                                "${widget.friendsAdded}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  // fontWeight:
                                                  // FontWeight.bold,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontFamily: "Arial",
                                                ),
                                              ),
                                              Text(
                                                " Friends",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  // fontWeight:
                                                  // FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  fontFamily: "Arial",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Container(
                                          width: 200,
                                          child: Text(
                                            widget.userBio,
                                            style: TextStyle(fontSize: 18, fontFamily: "Arial"),
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            // softWrap: false,
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: SocialGridWidget(),
                                      ),

                                      SizedBox(height: 20),
                                      // For Desktop Web version
                                      Visibility(
                                        visible: isContactEnabled,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await URL.launchURL(usernames["Contact"]);
                                          },
                                          child: Container(
                                            width: 250,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Image.asset(
                                                  "assets/images/SMLogos/ContactLogo.png",
                                                  height: 50,
                                                ),
                                                Text(
                                                  "Add To Contacts",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.download,
                                                  size: 25,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.black,
                                            primary: Colors.white,
                                            // side: BorderSide(color: Colors.cyan[400]!, width: 2),
                                            elevation: 20,
                                            padding: const EdgeInsets.all(15.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GetYourOwnCard()
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
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
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  URL.launchURL("https://www.soshi.org/");
                                },
                                child: Image.asset(
                                  "assets/images/SoshiLogos/soshi_logo.png",
                                  height: 30,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
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
                                        child: ProfilePic(radius: height / 7, url: photoURL),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        children: [
                                          Text(
                                            fullName,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Arial"),
                                          ),
                                          SizedBox(height: 2),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "@" + widget.soshiUsername,
                                                style: TextStyle(
                                                    // color: Colors.cyan[300],
                                                    color: Colors.black,
                                                    letterSpacing: 2,
                                                    fontSize: 15,
                                                    // fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    fontFamily: "Arial"),
                                              ),
                                              SizedBox(width: 2),
                                              widget.isVerified
                                                  ? Icon(Icons.verified, color: Colors.blue)
                                                  : Container(),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(20))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(7.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.emoji_people,
                                                    color: Colors.black,
                                                    size: 15,
                                                  ),
                                                  Text(
                                                    "${widget.friendsAdded}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      // fontWeight:
                                                      // FontWeight.bold,
                                                      fontWeight: FontWeight.bold,
                                                      fontStyle: FontStyle.italic,
                                                      fontFamily: "Arial",
                                                    ),
                                                  ),
                                                  Text(
                                                    " Friends",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      // fontWeight:
                                                      // FontWeight.bold,
                                                      fontStyle: FontStyle.italic,
                                                      fontFamily: "Arial",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // {?} This is going to be the Bio
                                          Container(
                                            width: 200,
                                            child: Text(
                                              widget.userBio,
                                              style: TextStyle(fontSize: 13, fontFamily: "Arial"),
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              // softWrap: false,
                                            ),
                                          ),
                                          SizedBox(height: 3)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                            ]),
                          ),
                        ),

                        SizedBox(height: 15),

                        Visibility(
                          visible: isContactEnabled,
                          child: ElevatedButton(
                            onPressed: () async {
                              await URL.launchURL(usernames["Contact"]);
                            },
                            child: Container(
                              height: height / 22,
                              width: width / 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset("assets/images/SMLogos/ContactLogo.png",
                                      width: width / 10),
                                  Text(
                                    "Add To Contacts + ",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              primary: Colors.white.withOpacity(0.6),
                              // side: BorderSide(color: Colors.cyan[400]!, width: 2),
                              elevation: 20,
                              padding: const EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          // color: Colors.red,
                          // height: MediaQuery.of(context).size.height - 460,
                          // height: double.infinity,
                          width: Responsive.isMobile(context)
                              ? MediaQuery.of(context).size.width - 50
                              : MediaQuery.of(context).size.width - 500,
                          child: SocialGridWidget(),
                        ),

// ------------- learn more Stuff

                        // GetYourOwnCard(height: height, width: width)

                        Divider(
                          thickness: 1,
                          color: Colors.transparent,
                        ),
                        SizedBox(height: 10),

                        Visibility(
                          visible: widget.isBusiness,
                          child: InkWell(
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
                                                    Icons.sentiment_very_dissatisfied,
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
                                                // maxLengthEnforced: true,
                                                style:
                                                    TextStyle(fontSize: 18.0, color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintText: "Type your feedback...",
                                                  contentPadding: const EdgeInsets.all(10),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(color: Colors.blue, width: 2.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(color: Colors.grey, width: 1.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print("SUBMIT GIVEN FEEDBACK to business!");
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              elevation: 7,
                                              child: Container(
                                                height: 40,
                                                width: 200,
                                                // decoration: fancyDecor,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue.withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.all(Radius.circular(10))),

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                            fontWeight: FontWeight.bold,
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
                                    borderRadius: BorderRadius.all(Radius.circular(10))),

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
                        ),
                      ]),
                  // DownloadSoshiBanner()
                ],
              ),
            ));
  }

  GridView SocialGridWidget() {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          // childAspectRatio: 1 / 1

          // maxCrossAxisExtent: 200, childAspectRatio: , crossAxisSpacing: 20, mainAxisSpacing: 20
        ),
        // itemCount: usernamesCopy.keys.length,
        itemBuilder: (BuildContext context, index) {
          // String currentKey =
          //     usernamesCopy.keys.elementAt(index);
          // print("creating SM button");

          // if (currentKey == "Menu") {
          //   return createMenue();
          // } else if (currentKey == "Website") {
          //   return createWebsite();
          // }

          return createSMButton(
              platform: visiblePlatforms[index],
              username: usernames[visiblePlatforms[index]],
              context: context);
        },
        itemCount: visiblePlatforms.length);
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
          borderRadius:
              BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Card(
        elevation: 10,
        color: Colors.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: Responsive.isDesktop(context) ? height / 8 : height / 5.5,
          width: width / 2,
          // height: 140,
          // width: 150,
          decoration: ShapeDecoration.fromBoxDecoration(
              BoxDecoration(borderRadius: BorderRadius.circular(15.0))),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                "Want all your socials in one place?",
                style: Responsive.isDesktop(context)
                    ? TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic)
                    : TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (defaultTargetPlatform != TargetPlatform.android) {
                    print("[+] Go to app store");
                    URL.launchURL("https://apps.apple.com/us/app/soshi/id1595515750");
                  } else {
                    print("[+] Go to play store");
                    URL.launchURL(
                        "https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                  }
                },
                child: Container(
                    height: height / 25,
                    width: Responsive.isDesktop(context) ? width / 5 : width / 2,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Get the App",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
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
                  elevation: 15,
                  padding: const EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

// class QuickContactSquare extends StatelessWidget {
//   Map contactData;

//   QuickContactSquare({required this.contactData});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         print("Contact button pressed");

//         print(contactData);

//         String url = URL.getPlatformURL(
//             platform: contactData["contact_name"],
//             username: contactData['contact_info']);

//         await launch(url);
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: Container(
//           height: 60,
//           width: 60,
//           // decoration: BoxDecoration(
//           //     shape: BoxShape.circle,
//           //     color: Colors.black.withOpacity(0.1),
//           //     // color: Colors.transparent,
//           //     border: Border.all(
//           //       color: Colors.black,
//           //       width: 2,
//           //     )),
//           child: Padding(
//             padding: const EdgeInsets.all(5.0),
//             // child: Icon(
//             //   contactData['contact_icon'],
//             //   color: Colors.black,
//             //   size: 30,
//             // )

//             child: Container(
//               child: Image.asset(
//                 "assets/images/SMLogos/" +
//                     contactData['contact_name'] +
//                     "Logo.png",
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
