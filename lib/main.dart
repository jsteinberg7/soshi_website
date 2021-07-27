import 'dart:html' as html;

import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'userinfo.dart';

String photoURL = "null";
String soshiUsername = "null";
String fullName = "null";
Map<String, dynamic> usernames = {};
List<String> visiblePlatforms = [];
bool valuesRetrieved = false;
String UID = "MB89JmQytNb9s1JjNUSfvCKQSSX2";

Future<void> fetchUserData() async {
  // get UID
  // UID = "MB89JmQytNb9s1JjNUSfvCKQSSX2";
  String URLPath = html.window.location.pathname.toString();
  // UID = URLPath.substring(URLPath.indexOf("/"));
  print("UID: " + UID);
  // UID = URL.substring(0, URL.indexOf('.app'));
  // retrieve all async values from database
  DatabaseService databaseService = new DatabaseService(UID: UID);
  photoURL = await databaseService.getPhotoURL(UID);
  soshiUsername =
      await databaseService.getUsernameForPlatform(platform: "Soshi");
  fullName = await databaseService.getFullName();
  usernames = await databaseService.getUserProfileNames();
  visiblePlatforms = await databaseService.getEnabledPlatformsList();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LoadingScreen());
  await Firebase.initializeApp();

  await fetchUserData();
  FluroRouter.appRouter.define("/", handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return UserInfoDisplay();
  }));
  // valuesRetrieved = true;
  runApp(MyApp());
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
      backgroundColor: Colors.white,
    ));
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final router = FluroRouter();

  @override
  void initState() {
    super.initState();
    // Routes.configureRoutes(router);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: UserInfoDisplay(),
        initialRoute: Uri.base.toString(),
        // onGenerateRoute: router.generator,
        color: Color(0xFF000034));
  }
}

class UserInfoDisplay extends StatefulWidget {
  const UserInfoDisplay({Key? key}) : super(key: key);

  @override
  _UserInfoDisplayState createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double height = queryData.size.width;
    double width = queryData.size.height;
    int index = 0;
    return Scaffold(
      backgroundColor: Color(0xFF000034),
      body: Container(
          alignment: Alignment.center,
          child: Flex(direction: Axis.vertical, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 5.0),
                child: CircleAvatar(
                    // backgroundImage: NetworkImage(photoURL),
                    radius: 30.0),
              ),
              Flex(
                direction: Axis.vertical,
                children: [
                  Text(
                    fullName,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan[600]),
                  ),
                  Text(
                    "@" + usernames["Soshi"],
                    style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.cyan[600],
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ]),
            Divider(color: Colors.cyan[600]),
            Padding(padding: EdgeInsets.only(top: height / 50)),
            Container(
              decoration: BoxDecoration(color: Color(0xFF00003F)),
              height: (height / 3) * (visiblePlatforms.length / 3).ceil(),
              width: width / 2,
              padding: EdgeInsets.only(top: height / 15),
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return Padding(padding: EdgeInsets.all(10.0));
                },
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int i) {
                  return Flex(direction: Axis.horizontal, children: [
                    UserInfo.createSMButton(
                        platform: visiblePlatforms[index],
                        username: usernames[visiblePlatforms[index++]],
                        context: context),
                    (index >= visiblePlatforms.length)
                        ? Text("")
                        : UserInfo.createSMButton(
                            platform: visiblePlatforms[index],
                            username: usernames[visiblePlatforms[index++]],
                            context: context),
                    (index >= visiblePlatforms.length)
                        ? Text("")
                        : UserInfo.createSMButton(
                            platform: visiblePlatforms[index],
                            username: usernames[visiblePlatforms[index++]],
                            context: context),
                  ]);
                },
                itemCount: (visiblePlatforms.length / 3).ceil(),
              ),
            )
          ])),
    );
  }
}

class Routes {
  static void configureRoutes(FluroRouter router) {
    // FluroRouter.appRouter.define("/",
    //     handler: Handler(handlerFunc: (_, params) {
    //   return UserInfoDisplay();
    // }));
  }
}

// class MyApp extends StatelessWidget {
//   // String URL = Uri.base.toString();
//   String UID = "";

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // set UID to all characters following base domain (set to extension)
//     // UID = URL.substring(0, URL.indexOf('m'));
//     // ** TESTING
//     UID = "MB89JmQytNb9s1JjNUSfvCKQSSX2";
//     // instantiate DatabaseService
//     return MaterialApp(home: Scaffold(body: userInformation(UID)));
//   }
// }

// // display user information
// Widget userInformation(String UID) {
//   DatabaseService databaseService = new DatabaseService(UID: UID);
//   return Container(
//       child: Column(children: [
//     Row(children: [
//       Padding(
//         padding: const EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 5.0),
//         child: FutureBuilder(
//             future: databaseService.getPhotoURL(UID),
//             // ignore: missing_return
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               if (snapshot.hasData) {
//                 return CircleAvatar(
//                     backgroundImage: NetworkImage(snapshot.data), radius: 30.0);
//               } else {
//                 return Text("loading...");
//               }
//             }),
//       ),
//       Column(
//         children: [
//           FutureBuilder(
//               future: databaseService.getFullName(),
//               builder:
//                   // ignore: missing_return
//                   (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                 if (snapshot.hasData) {
//                   return Text(
//                     snapshot.data,
//                     style: TextStyle(
//                         fontSize: 25.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.cyan[600]),
//                   );
//                 } else {
//                   return Text("else");
//                 }
//               }),
//           FutureBuilder(
//               future: databaseService.getUsernameForPlatform(platform: "Soshi"),
//               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                 if (snapshot.hasData) {
//                   return Text(
//                     "@" + snapshot.data,
//                     style: TextStyle(
//                         fontSize: 10.0,
//                         color: Colors.cyan[600],
//                         fontStyle: FontStyle.italic),
//                   );
//                 } else {
//                   return Text("loading");
//                 }
//               }),
//           Divider(color: Colors.cyan[600]),
//           // FutureBuilder(
//           //     future: databaseService.getEnabledPlatformsList(),
//           //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           //       return Container(
//           //         height: 230.0,
//           //         width: 260.0,
//           //         padding: EdgeInsets.only(top: 10.0),
//           //         child: ListView.separated(
//           //           separatorBuilder: (BuildContext context, int i) {
//           //             return Padding(padding: EdgeInsets.all(10.0));
//           //           },
//           //           scrollDirection: Axis.vertical,
//           //           itemBuilder: (BuildContext context, int i) {
//           //             return Row(children: [
//           //               UserInfo.createSMButton(
//           //                   platform: visiblePlatforms[index],
//           //                   username: usernames[visiblePlatforms[index++]]),
//           //               (index >= visiblePlatforms.length)
//           //                   ? Text("")
//           //                   : UserInfo.createSMButton(
//           //                       platform: visiblePlatforms[index],
//           //                       username: usernames[visiblePlatforms[index++]],
//           //                     ),
//           //               (index >= visiblePlatforms.length)
//           //                   ? Text("")
//           //                   : UserInfo.createSMButton(
//           //                       platform: visiblePlatforms[index],
//           //                       username: usernames[visiblePlatforms[index++]],
//           //                     ),
//           //             ]);
//           //           },
//           //           itemCount: (visiblePlatforms.length / 3).ceil(),
//           //         ),
//           //       );
//           //     }),
//         ],
//       ),
//     ])
//   ]));
// }
