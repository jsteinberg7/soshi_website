import 'package:flutter/material.dart';
import 'package:soshi/url.dart';

import 'constants/constants.dart';

class PageNotFoundScreen extends StatefulWidget {
  bool launchURL = false;
  PageNotFoundScreen({bool launchURLIn = false}) {
    launchURL = launchURLIn;
  }

  @override
  State<PageNotFoundScreen> createState() => _PageNotFoundScreenState();
}

class _PageNotFoundScreenState extends State<PageNotFoundScreen> {
  @override
  void initState() {
    super.initState();
    // if (widget.launchURL) {

    //   URL.launchURL("https://www.soshi.org/");
    // }
  }

  @override
  Widget build(BuildContext context) {
    double height = Constants.getHeight(context);
    double width = Constants.getWidth(context);
    return Scaffold(
        backgroundColor: Color(0x59ECFF),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: height / 7),
              GestureDetector(
                onTap: () {
                  URL.launchURL("https://www.soshi.org/");
                },
                child: Image.asset(
                  "assets/images/SoshiLogos/soshi_logo.png",
                  height: height / 10,
                ),
              ),
              SizedBox(height: height / 7),
              Container(
                height: height / 3,
                width: width / 1.5,
                decoration: ShapeDecoration.fromBoxDecoration(BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15.0))),
                child: Flex(direction: Axis.vertical, children: [
                  Padding(
                    padding: EdgeInsets.all(width / 40),
                    child: Text(
                      'The user you\'re looking for could not be found :(\nDownload our app to create your own digital contact card and join the Soshi community!',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontSize: width / 20),
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
                          // IconButton(

                          //   onPressed: () {
                          //     URL.launchURL(
                          //         "https://play.google.com/store?hl=en_US&gl=US");
                          //   },
                          //   iconSize: width / 3,
                          // icon:
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
                          SizedBox(width: width / 25),
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
            ],
          ),
        ));
  }
}
