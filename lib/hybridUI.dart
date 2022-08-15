import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:soshi/database.dart';
import 'package:soshi/mobileView.dart';
import 'package:soshi/responsive.dart';
import 'package:soshi/url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/constants.dart';
import 'constants/widgets.dart';
import 'package:flutter/foundation.dart';

import 'desktopView.dart';

bool biz = true;

class HybridUI extends StatefulWidget {
  String username;

  HybridUI(this.username);

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
  late String username;

  @override
  void initState() {
    // this.fullName = widget.fullName;
    // this.usernames = widget.usernames;
    // this.visiblePlatforms = widget.visiblePlatforms;
    // if (visiblePlatforms.contains("Contact")) {
    //   visiblePlatforms.remove("Contact");
    //   isContactEnabled = true;
    // }
    // this.photoURL = widget.photoURL;
    username = widget.username;
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
          await URL.launchURL(
              URL.getPlatformURL(platform: platform, username: username));
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

// NEW RESPONSIVE
    return Responsive.isDesktop(context)
        // ? Container()
        ? DesktopView(
            friendSoshiUsername: username,
          )
        : Scaffold(body: MobileView(friendSoshiUsername: username));
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

  // Widget _buildContainer(double radius) {
  //   return Container(
  //     width: radius,
  //     height: radius,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: Colors.blue.withOpacity(1 - _controller.value),
  //     ),
  //   );
  // }
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
                    // print("[+] Go to app store");
                    URL.launchURL(
                        "https://apps.apple.com/us/app/soshi/id1595515750");
                  } else {
                    // print("[+] Go to play store");
                    URL.launchURL(
                        "https://play.google.com/store/apps/details?id=com.swoledevs.soshi&hl=en&gl=US");
                  }
                },
                child: Container(
                    height: height / 25,
                    width:
                        Responsive.isDesktop(context) ? width / 5 : width / 2,
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
