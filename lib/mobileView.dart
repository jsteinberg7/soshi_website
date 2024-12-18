import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smart_banner/smart_banner.dart';
import 'package:soshi/analytics.dart';
import 'package:soshi/url.dart';

import 'package:form_validator/form_validator.dart';

import '../../../constants/widgets.dart';

import 'package:glassmorphism/glassmorphism.dart';

import 'package:uuid/uuid.dart';

import 'constants/loading.dart';
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
            List<dynamic> skills = databaseService.getSkills(userData);

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

            // Future.delayed(Duration(milliseconds: 4000), () {
            //   swapInfoForm(context, fullName.split(" ").first, profilePhotoURL,
            //       friendSoshiUsername);
            // });
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
                                    ? Colors.black
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
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Center(
                                          child: AutoSizeText(
                                            fullName,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: width / 15,
                                            ),
                                          ),
                                        )),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     swapInfoForm(
                                        //         context,
                                        //         fullName.split(" ").first,
                                        //         profilePhotoURL,
                                        //         friendSoshiUsername);
                                        //   },
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.fromLTRB(
                                        //         5, 5, 0, 0),
                                        //     child: Icon(
                                        //         Icons.person_add_alt_1_sharp),
                                        //   ),
                                        // )
                                      ],
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
                                      width / 7.5, height / 70, width / 7.5, 0),
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
                              // Visibility(
                              //   visible: !skills.isEmpty,
                              //   child: Padding(
                              //     padding: EdgeInsets.only(top: height / 100),
                              //     child: Wrap(
                              //       alignment: WrapAlignment.center,
                              //       spacing: width / 65,
                              //       children:
                              //           List.generate(skills.length, (i) {
                              //         return SkillBubble(skills[i]);
                              //       }),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: height / 2.35,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: isContactEnabled,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: Container(
                                width: width / 1.3,
                                child: NeumorphicButton(
                                  style: NeumorphicStyle(
                                      shadowDarkColor: Colors.black,
                                      shadowLightColor: Colors.transparent,
                                      color: Colors.transparent,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(20.0))),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async {
                                    try {
                                      await URL.launchURL(usernames["Contact"]);
                                      // add contact added analytic here?
                                    } catch (e) {}

                                    //pop up of swap?
                                    swapInfoForm(
                                        context,
                                        fullName.split(" ").first,
                                        profilePhotoURL,
                                        friendSoshiUsername);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color.fromARGB(255, 192, 33, 246),
                                        Color.fromARGB(255, 21, 175, 218)
                                      ]),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(19.0)),
                                    ),
                                    width: width / 1.3,
                                    height: height / 17,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Add to Contacts',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          letterSpacing: 1.4,
                                          fontSize: width / 23,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),

                                // child: NeumorphicButton(
                                //     onPressed: () async {
                                //       try {
                                //         await URL
                                //             .launchURL(usernames["Contact"]);
                                //         // add contact added analytic here?
                                //       } catch (e) {}

                                //       //pop up of swap?
                                //       swapInfoForm(
                                //           context,
                                //           fullName.split(" ").first,
                                //           profilePhotoURL,
                                //           friendSoshiUsername);
                                //     },
                                //     child: Text(
                                //       "Add to Contacts",
                                //       textAlign: TextAlign.center,
                                //       style: TextStyle(
                                //           letterSpacing: 1.4, fontSize: 20),
                                //     ),
                                //     style: NeumorphicStyle(
                                //         shadowDarkColor: Colors.black,
                                //         shadowLightColor: Colors.black12,
                                //         color: Colors.blue,
                                //         boxShape: NeumorphicBoxShape.roundRect(
                                //             BorderRadius.circular(19.0)))),
                              ),
                            )),

                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              width / 25, width / 30, 0, width / 80),
                          child: Row(
                            children: [
                              Text(
                                "Skills",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width / 18),
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: Padding(
                                padding: EdgeInsets.only(top: height / 100),
                                child: !skills.isEmpty
                                    ? Container(
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: width / 65,
                                          children:
                                              List.generate(skills.length, (i) {
                                            return SkillBubble(skills[i]);
                                          }),
                                        ),
                                      )
                                    : Text(
                                        "This user is not sharing their skills.",
                                        style: TextStyle(fontSize: width / 30),
                                      ))),

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
                        //       child: AddToContactsButton(
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
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      URL.launchURL("https://soshi.org");
                    },
                    child: Container(
                      width: width / 10,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Image.asset(
                            "assets/images/SoshiLogos/new_logo_white.png",
                          )),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: ClipRRect(
                        child: GestureDetector(
                            onTap: () {
                              Analytics.logPressGetAppButton();
                              if (defaultTargetPlatform !=
                                  TargetPlatform.android) {
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
                                width: 45,
                                height: 45,
                                child: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    swapInfoForm(
                                        context,
                                        fullName.split(" ").first,
                                        profilePhotoURL,
                                        friendSoshiUsername);
                                  },
                                ))

                            // ClipRRect(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10)),
                            //     child: Image.asset(
                            //       "assets/images/SoshiLogos/new_soshi_icon.png",
                            //     ))),
                            ))),

                //GetTheAppBanner(height / 15, width)
                //       ),
                // )
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
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      // SizedBox(width: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
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

void swapInfoForm(BuildContext context, String firstname, String profilePicURL,
    String soshiUsernameRecieving) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  TextEditingController nameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController jobTitleController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();

  DatabaseService dbService =
      new DatabaseService(soshiUsernameIn: soshiUsernameRecieving);

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero)),
              height: height / 1.1,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                          //height: height / 50,
                          height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            ProfilePic(radius: 60, url: profilePicURL),
                            SizedBox(
                              width: width / 30,
                            ),
                            Flexible(
                              child: Text(
                                "Send your information back to $firstname.",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ]),
                      //SizedBox(height: height / 40),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(left: 10, right: 10, top: 10),
                      //   child: Divider(
                      //     color: Colors.white,
                      //     thickness: .3,
                      //   ),
                      // ),
                      SizedBox(height: height / 80),
                      Row(
                        children: [
                          Expanded(
                              child: swapTextField(
                                  "Name", "name", nameController)),
                          Expanded(
                              child: swapTextField("Phone Number",
                                  "phonenumber", numberController)),
                        ],
                      ),
                      SizedBox(height: height / 40),
                      swapTextField("Email", "name", emailController),
                      SizedBox(height: height / 40),
                      Row(
                        children: [
                          Expanded(
                              child: swapTextField(
                                  "Job Title", "name", jobTitleController)),
                          Expanded(
                              child: swapTextField(
                                  "Company", "name", companyController)),
                        ],
                      ),
                      // swapTextField("Job Title", "name", jobTitleController),
                      // SizedBox(height: height / 40),
                      // swapTextField("Company", "name", companyController),
                      SizedBox(height: height / 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NeumorphicButton(
                            padding: EdgeInsets.zero,
                            style: NeumorphicStyle(
                                shadowDarkColor: Colors.black,
                                shadowLightColor: Colors.black12,
                                color: Colors.transparent,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(20.0))),
                            onPressed: () async {
                              DialogBuilder(context).showLoadingIndicator(
                                  "Sending information to $firstname.");
                              await dbService.writeSwapInformation(
                                  soshiUsernameRecieving,
                                  nameController.text,
                                  numberController.text,
                                  emailController.text,
                                  jobTitleController.text,
                                  companyController.text);
                              DialogBuilder(context).hideOpenDialog();
                              Navigator.of(context).pop();
                              // Pop up that info has been sent
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 192, 33, 246),
                                  Color.fromARGB(255, 21, 175, 218)
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(19.0)),
                              ),
                              width: width / 1.5,
                              height: height / 15,
                              alignment: Alignment.center,
                              child: Text(
                                'Send My Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    letterSpacing: 1.4,
                                    fontSize: width / 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: height / 40),
                          NeumorphicButton(
                            padding: EdgeInsets.zero,
                            style: NeumorphicStyle(
                                shadowDarkColor: Colors.black,
                                shadowLightColor: Colors.black12,
                                color: Colors.transparent,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(20.0))),
                            onPressed: () async {
                              DialogBuilder(context).hideOpenDialog();
                              // Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(19.0)),
                              ),
                              width: width / 1.7,
                              height: height / 18,
                              alignment: Alignment.center,
                              child: Text('No Thanks',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      letterSpacing: 1.4,
                                      fontSize: width / 23,
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
          ));
}

Padding swapTextField(
    String hinttext, String autofill, TextEditingController textController) {
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: TextFormField(
      autofocus: true,
      autofillHints: hinttext == "Namme"
          ? [AutofillHints.name]
          : hinttext == "Phone Number"
              ? [AutofillHints.telephoneNumber]
              : hinttext == "Email"
                  ? [AutofillHints.email]
                  : hinttext == "Job Title"
                      ? [AutofillHints.jobTitle]
                      : [AutofillHints.organizationName],
      keyboardType: hinttext == "Name"
          ? TextInputType.name
          : hinttext == "Phone Number"
              ? TextInputType.phone
              : TextInputType.text,
      controller: textController,
      decoration: InputDecoration(
          hintText: hinttext,
          contentPadding: EdgeInsets.fromLTRB(5, 20, 20, 20),
          hintStyle: TextStyle(fontSize: 18),
          focusColor: Colors.cyan),
      style: TextStyle(fontSize: 18),
    ),
  );
}
