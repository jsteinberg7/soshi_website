import 'dart:html';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:soshi/hybridUI.dart';

import 'package:soshi/page_not_found_screen.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

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

// Future<User> fetchUserData(String soshiUsername) async {
//   var url = window.location.href;
//   print("URL: " + url);

//   print("attempt to fetch user data base using $soshiUsername");

//   DatabaseService databaseService =
//       new DatabaseService(soshiUsernameIn: soshiUsername);

//   print("got data back from database!");

//   var userData = await databaseService.getUserFile(soshiUsername);

//   print("after data print>?");

//   print(userData);

//   String photoURL = databaseService.getPhotoURL(userData);
//   String fullName = databaseService.getFullName(userData);

//   Map<String, dynamic> usernames =
//       databaseService.getUserProfileNames(userData);
//   List<String> visiblePlatforms =
//       await databaseService.getEnabledPlatformsList(userData);
//   String userBio = databaseService.getBio(userData);
//   int friendsAdded = databaseService.getFriendsCount(userData);
//   print("friends added: " + friendsAdded.toString());
//   print("bio: " + userBio);
//   bool isVerified = databaseService.getVerifiedStatus(userData);

//   // DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

//   // Map<String, dynamic> _deviceData = <String, dynamic>{};

//   // Map OSData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);

//   // print("printing user data:  " + OSData.toString());

//   return User(
//       fullName: fullName,
//       usernames: usernames,
//       visiblePlatforms: visiblePlatforms,
//       photoURL: photoURL,
//       soshiUsername: soshiUsername,
//       // userBio: OSData.toString(),
//       userBio: userBio,
//       friendsAdded: friendsAdded,
//       isVerified: isVerified);
// }

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Brightness brightness;
  @override
  void initState() {
    super.initState();
    brightness = ui.PlatformDispatcher.instance.platformBrightness;
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
        themeMode:
            brightness == ui.Brightness.dark ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          fontFamily: GoogleFonts.inter().fontFamily,
          brightness: Theme.of(context).brightness,
          backgroundColor: Colors.grey[50],
          primarySwatch: MaterialColor(
            0xFFE7E7E7,
            <int, Color>{
              50: Color.fromARGB(26, 223, 247, 248),
              100: Color.fromARGB(26, 199, 230, 231),
              200: Color.fromARGB(26, 187, 223, 224),
              300: Color.fromARGB(26, 173, 206, 207),
              400: Color.fromARGB(26, 153, 186, 187),
              500: Color.fromARGB(26, 161, 193, 194),
              600: Color.fromARGB(26, 152, 179, 180),
              700: Color.fromARGB(26, 124, 152, 153),
              800: Color.fromARGB(26, 95, 139, 141),
              900: Color.fromARGB(26, 64, 116, 117),
            },
          ),
          //primaryColor: Color.fromARGB(255, 179, 225, 237),
          primaryColorLight: Color.fromARGB(255, 179, 225, 237),
          // primaryColorDark: Colors.grey[850],
          canvasColor: Color.fromARGB(255, 191, 200, 202),
          scaffoldBackgroundColor: Colors.grey[50],
          bottomAppBarColor: Color.fromARGB(255, 0, 0, 0),
          appBarTheme: AppBarTheme(color: Colors.grey[50]),
          cardColor: Colors.white,
          dividerColor: Color(0x1f6D42CE),
          focusColor: Color(0x1aF5E0C3),

          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Colors.cyan[500]),
          elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return Colors.white;
            }),
          )),
          // , buttonTheme: ButtonTheme()
        ),
        darkTheme: ThemeData(
            fontFamily: GoogleFonts.inter().fontFamily,
            brightness: Brightness.dark,
            backgroundColor: Colors.grey[850],
            primarySwatch: MaterialColor(
              0xFFF5E0C3,
              <int, Color>{
                50: Color(0x1a5D4524),
                100: Color(0xa15D4524),
                200: Color(0xaa5D4524),
                300: Color(0xaf5D4524),
                400: Color(0x1a483112),
                500: Color(0xa1483112),
                600: Color(0xaa483112),
                700: Color(0xff483112),
                800: Color(0xaf2F1E06),
                900: Color(0xff2F1E06)
              },
            ),
            primaryColor: Colors.grey[850],
            primaryColorLight: Color(0x1a311F06),
            primaryColorDark: Colors.black,
            canvasColor: Colors.grey[850],
            scaffoldBackgroundColor: Colors.grey[900],
            bottomAppBarColor: Color(0xff6D42CE),
            cardColor: Colors.grey[900],
            dividerColor: Color(0x1f6D42CE),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              // MaterialStateProperty.resolveWith<TextStyle>(Set<MaterialState> states) {
              //   return TextStyle(color: Colors.white);
              // }

              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.grey[900]!;
              }),
              elevation: MaterialStateProperty.resolveWith<double>(
                  (Set<MaterialState> states) {
                return 5.0;
              }),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.white;
              }),
            )),
            focusColor: Color(0x1a311F06)),
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
          //UID = "yuvansun";

          if (params.length >= 1
              // &&
              // (params[1] == "user" || params[1] == "u") &&
              // (params.last != "user" && params.last != "u")
              ) {
            print(">>>> UID: " + UID);
            return MaterialPageRoute(
                settings: settings,
                builder: (context) {
                  return HybridUI(UID);
                  // return Container();
                });
          } else {
            return MaterialPageRoute(builder: (context) {
              double height = MediaQuery.of(context).size.height;
              double width = MediaQuery.of(context).size.width;

              return PageNotFoundScreen(height, width);
            });
          }
        });
  }
}
