import 'dart:html';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:soshi/constants/constants.dart';
import 'package:soshi/newProfileUI.dart';
import 'package:soshi/page_not_found_screen.dart';
import 'package:soshi/url.dart';
import 'package:soshi/user.dart';
import 'package:soshi/userinfodisplay.dart';
import 'customUrlStrategy.dart';
import 'database.dart';
import 'loading_screen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

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

  return new User(
      fullName: fullName,
      usernames: usernames,
      visiblePlatforms: visiblePlatforms,
      photoURL: photoURL,
      soshiUsername: soshiUsername,
      userBio: userBio,
      friendsAdded: friendsAdded);
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
    if (inputURL.contains("#")) {
      window.history.pushState(null, "User", "/user/${inputURL.last}");
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
          // if URL has slash at end, remove slash from UID
          if (UID.endsWith('/')) {
            UID = UID.replaceAll('/', '');
          }
          // String UID = "yuvansun";

          if (params.length >= 2 &&
              params[1] == "user" &&
              params.last != "user") {
            print("params:" + params.toString());
            // if (true) {
            return MaterialPageRoute(
                settings: settings,
                builder: (context) {
                  return FutureBuilder(
                      future: fetchUserData(UID),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          User user = snapshot.data as User;
                          return UserInfoDisplay(
                            fullName: user.fullName,
                            usernames: user.usernames,
                            visiblePlatforms: user.visiblePlatforms,
                            photoURL: user.photoURL,
                            bio: user.userBio,
                            friendsAdded: user.friendsAdded,
                            //soshiUsername: user.soshiUsername,
                            //userBio: user.userBio
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
