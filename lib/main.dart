import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:soshi_website/page_not_found_screen.dart';
import 'package:soshi_website/user.dart';
import 'package:soshi_website/userinfodisplay.dart';
import 'database.dart';
import 'loading_screen.dart';

void main() async {
  // Routes.setupRouter();
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(LoadingScreen());
  // Routes.setupRouter();
  await Firebase.initializeApp();
  runApp(MyApp());
  // runApp(PageNotFoundScreen());
}

Future<User> fetchUserData(String UID) async {
  // get UID
  // UID = "MB89JmQytNb9s1JjNUSfvCKQSSX2";
  // String URLPath = Uri.base.toString();
  // print("Params " + Uri.base.queryParameters.toString());
  // print("URLPath: " + URLPath);
  // UID = URLPath.substring(URLPath.indexOf("/#/") + 3);
  // print("UID: " + UID);
  // retrieve all async values from database
  DatabaseService databaseService = new DatabaseService(UID: UID);
  String photoURL = await databaseService.getPhotoURL(UID);
  String soshiUsername =
      await databaseService.getUsernameForPlatform(platform: "Soshi");
  String fullName = await databaseService.getFullName();
  Map<String, dynamic> usernames = await databaseService.getUserProfileNames();
  List<String> visiblePlatforms =
      await databaseService.getEnabledPlatformsList();
  return new User(
      fullName: fullName,
      usernames: usernames,
      visiblePlatforms: visiblePlatforms);
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final router = Routes.router;

  @override
  void initState() {
    super.initState();
    // Routes.configureRoutes(router);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: "/",
        onGenerateRoute: (settings) {
          List<String> params = settings.name!.split("/");
          String UID = params.last;
          if (params[4] == "user") {
            return MaterialPageRoute(builder: (context) {
              return FutureBuilder(
                  future: fetchUserData(UID),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      User user = snapshot.data as User;
                      return UserInfoDisplay(
                          fullName: user.fullName,
                          usernames: user.usernames,
                          visiblePlatforms: user.visiblePlatforms);
                    } else {
                      return LoadingScreen();
                    }
                  });
            });
          } else {
            return MaterialPageRoute(builder: (context) {
              return PageNotFoundScreen();
            });
          }
        });
  }
}
