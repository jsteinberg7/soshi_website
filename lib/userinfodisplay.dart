import 'package:flutter/material.dart';
import 'package:soshi_website/url.dart';

class UserInfoDisplay extends StatefulWidget {
  String fullName = "";
  Map<String, dynamic> usernames = {};
  List<String> visiblePlatforms = [];
  String photoURL = "";

  UserInfoDisplay(
      {required String fullName,
      required Map<String, dynamic> usernames,
      required List<String> visiblePlatforms,
      required String photoURL}) {
    this.fullName = fullName;
    this.usernames = usernames;
    this.visiblePlatforms = visiblePlatforms;
    this.photoURL = photoURL;
  }

  @override
  _UserInfoDisplayState createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {
  String fullName = "";
  Map<String, dynamic> usernames = {};
  List<String> visiblePlatforms = [];
  String photoURL = "";

  @override
  void initState() {
    super.initState();
    this.fullName = widget.fullName;
    this.usernames = widget.usernames;
    this.visiblePlatforms = widget.visiblePlatforms;
    this.photoURL = widget.photoURL;
  }

  // Create a clickable social media icon
  static Widget createSMButton(
      {required String platform,
      required String username,
      required BuildContext context}) {
    return IconButton(
      splashColor: Colors.cyan[600],
      splashRadius: 55.0,
      icon: Image.asset(
        "assets/images/SMLogos/" + platform + "Logo.png",
      ),
      onPressed: () {
        URL.launchURL(
            URL.getPlatformURL(platform: platform, username: username));
      },
      iconSize: MediaQuery.of(context).size.height / 8,
    );
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
                    backgroundImage: NetworkImage(photoURL), radius: 30.0),
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
                    createSMButton(
                        platform: visiblePlatforms[index],
                        username: usernames[visiblePlatforms[index++]],
                        context: context),
                    (index >= visiblePlatforms.length)
                        ? Text("")
                        : createSMButton(
                            platform: visiblePlatforms[index],
                            username: usernames[visiblePlatforms[index++]],
                            context: context),
                    (index >= visiblePlatforms.length)
                        ? Text("")
                        : createSMButton(
                            platform: visiblePlatforms[index],
                            username: usernames[visiblePlatforms[index++]],
                            context: context),
                  ]);
                },
                itemCount: (visiblePlatforms.length / 3).ceil(),
              ),
            ),
            Dialog(
                child: Container(
                    child: ElevatedButton(
                        child: Text("Download Our App"),
                        onPressed: () {
                          URL.launchURL(
                              "https://play.google.com/store?hl=en_US&gl=US");
                        }),
                    color: Colors.grey[50]))
          ])),
    );
  }
}
