import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:soshi/constants/constants.dart';
import 'package:soshi/page_not_found_screen.dart';
import 'package:soshi/url.dart';
import 'package:soshi/user.dart';
import 'package:soshi/userinfodisplay.dart';
import 'database.dart';
import 'loading_screen.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  // setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Future<User> fetchUserData(String soshiUsername) async {
  DatabaseService databaseService =
      new DatabaseService(soshiUsernameIn: soshiUsername);
  Map userData = await databaseService.getUserFile(soshiUsername);
  String photoURL = databaseService.getPhotoURL(userData);
  String fullName = databaseService.getFullName(userData);
  Map<String, dynamic> usernames =
      databaseService.getUserProfileNames(userData);
  List<String> visiblePlatforms =
      await databaseService.getEnabledPlatformsList(userData);
  return new User(
      fullName: fullName,
      usernames: usernames,
      visiblePlatforms: visiblePlatforms,
      photoURL: photoURL);
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
    return MaterialApp(
        theme: Constants.CustomTheme,
        initialRoute: "/",
        onGenerateRoute: (settings) {
          List<String> params = settings.name!.split("/");
          String UID = params.last;
          if (params.contains("user")) {
            return MaterialPageRoute(builder: (context) {
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
