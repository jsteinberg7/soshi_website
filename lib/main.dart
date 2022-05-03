import 'dart:html';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:soshi/constants/constants.dart';
import 'package:soshi/hybridUI.dart';
import 'package:soshi/newProfileUI.dart';
import 'package:soshi/page_not_found_screen.dart';
import 'package:soshi/sri_ui_version_2.dart';
import 'package:soshi/url.dart';
import 'package:soshi/user.dart';
import 'package:soshi/userinfodisplay_backup.dart';
import 'customUrlStrategy.dart';
import 'database.dart';
import 'loading_screen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import "package:os_detect/os_detect.dart" as Platform;

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
//   return <String, dynamic>{
//     'browserName': describeEnum(data.browserName),
//     'appCodeName': data.appCodeName,
//     'appName': data.appName,
//     'appVersion': data.appVersion,
//     'deviceMemory': data.deviceMemory,
//     'language': data.language,
//     'languages': data.languages,
//     'platform': data.platform,
//     'product': data.product,
//     'productSub': data.productSub,
//     'userAgent': data.userAgent,
//     'vendor': data.vendor,
//     'vendorSub': data.vendorSub,
//     'hardwareConcurrency': data.hardwareConcurrency,
//     'maxTouchPoints': data.maxTouchPoints,
//   };
// }

Future<User> fetchUserData(String soshiUsername) async {
  var url = window.location.href;
  print("URL: " + url);

  print("attempt to fetch user data base using $soshiUsername");

  DatabaseService databaseService =
      new DatabaseService(soshiUsernameIn: soshiUsername);

  print("got data back from database!");

  var userData = await databaseService.getUserFile(soshiUsername);

  print("after data print>?");

  print(userData);

  String photoURL = databaseService.getPhotoURL(userData);
  String fullName = databaseService.getFullName(userData);

  Map<String, dynamic> usernames =
      databaseService.getUserProfileNames(userData);
  List<String> visiblePlatforms =
      await databaseService.getEnabledPlatformsList(userData);
  String userBio = databaseService.getBio(userData);
  int friendsAdded = databaseService.getFriendsCount(userData);
  print("friends added: " + friendsAdded.toString());
  print("bio: " + userBio);
  bool isVerified = databaseService.getVerifiedStatus(userData);

  // DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  // Map<String, dynamic> _deviceData = <String, dynamic>{};

  // Map OSData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);

  // print("printing user data:  " + OSData.toString());

  return User(
      fullName: fullName,
      usernames: usernames,
      visiblePlatforms: visiblePlatforms,
      photoURL: photoURL,
      soshiUsername: soshiUsername,
      // userBio: OSData.toString(),
      userBio: userBio,
      friendsAdded: friendsAdded,
      isVerified: isVerified);
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* remove # if necessary */
    print("URL: " + window.location.href);
    List<String> inputURL = window.location.href.split("/");
    if (inputURL.contains("#") || inputURL.contains("user")) {
      window.history.pushState(null, "Profile", "/${inputURL.last}");
    }
    // window.history.pushState(null, "Home", "/#/user/testing");
    // print("pushing url");
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Constants.CustomTheme,
        initialRoute: "/",
        onGenerateRoute: (settings) {
          print("SETTINGS: " + settings.toString());
          List<String> params = settings.name!.split("/");
          String UID = params.last;

          //UID = "sri";

          // if URL has slash at end, remove slash from UID
          if (UID.endsWith('/')) {
            UID = UID.replaceAll('/', '');
          }
          // String UID = "yuvansun";

          if (params.length >= 1
              // &&
              // (params[1] == "user" || params[1] == "u") &&
              // (params.last != "user" && params.last != "u")
              ) {
            return MaterialPageRoute(
                settings: settings,
                builder: (context) {
                  return FutureBuilder(
                      future: fetchUserData(UID),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          User user = snapshot.data as User;
                          // return UserInfoDisplay(
                          //   visiblePlatforms: user.visiblePlatforms,
                          //   fullName: user.fullName,
                          //   usernames: user.usernames,
                          //   photoURL: user.photoURL,
                          //   bio: user.userBio,
                          //   friendsAdded: user.friendsAdded,
                          // );
                          return AnimatedGradient(
                            child: HybridUI(
                              fullName: user.fullName,
                              usernames: user.usernames,
                              visiblePlatforms: user.visiblePlatforms,

                              //   visiblePlatforms: user.visiblePlatforms                         photoURL: user.photoURL,
                              // bio: user.userBio,
                              friendsAdded: user.friendsAdded,
                              isVerified: user.isVerified,
                              soshiUsername: user.soshiUsername,
                              userBio: user.userBio, photoURL: user.photoURL,
                              isBusiness: false,
                              //soshiUsername: user.soshiUsername,
                              //userBio: user.userBio
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingScreen();
                        } else {
                          return PageNotFoundScreen(launchURLIn: false);
                        }
                      });
                });
          } else {
            return MaterialPageRoute(builder: (context) {
              return PageNotFoundScreen(
                launchURLIn: true,
              );
            });
          }
        });
  }
}
