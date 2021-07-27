import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database.dart';

import 'url.dart';

/*
Custom popup dialogs
*/
class UserInfo {
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

  // display user information
  Widget userInformation({required String UID}) {
    DatabaseService databaseService = new DatabaseService(UID: UID);
    return Container(
        child: Column(children: [
      Row(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 5.0),
          child: FutureBuilder(
              future: databaseService.getPhotoURL(UID),
              // ignore: missing_return
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data),
                      radius: 30.0);
                } else {
                  return Text("loading");
                }
              }),
        ),
        Column(
          children: [
            FutureBuilder(
                future: databaseService.getFullName(),
                builder:
                    // ignore: missing_return
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan[600]),
                    );
                  } else {
                    return Text("loading");
                  }
                }),
            FutureBuilder(
                future:
                    databaseService.getUsernameForPlatform(platform: "Soshi"),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Text(
                    "@" + snapshot.data,
                    style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.cyan[600],
                        fontStyle: FontStyle.italic),
                  );
                }),
          ],
        )
      ])
    ]));
  }

// child: Column(children: [
  //   Row(children: [
  // Padding(
  //   padding: const EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 5.0),
  //   child: CircleAvatar(
  //       backgroundImage: NetworkImage(profilePhotoURL),
  //       radius: 30.0),
  // ),
  // Column(
  //   children: [
  //     Text(
  //       fullName,
  //       style: TextStyle(
  //           fontSize: 25.0,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.cyan[600]),
  //     ),
  //     Text(
  //       "@" + usernames["Soshi"],
  //       style: TextStyle(
  //           fontSize: 10.0,
  //           color: Colors.cyan[600],
  //           fontStyle: FontStyle.italic),
  //     ),
  //   ],
  // ),
  //   ]),
  //   Divider(color: Colors.cyan[600]),
  //   Container(
  //     height: 230.0,
  //     width: 260.0,
  //     padding: EdgeInsets.only(top: 10.0),
  //     child: ListView.separated(
  //       separatorBuilder: (BuildContext context, int i) {
  //         return Padding(padding: EdgeInsets.all(10.0));
  //       },
  //       scrollDirection: Axis.vertical,
  //       itemBuilder: (BuildContext context, int i) {
  //         return Row(children: [
  //           createSMButton(
  //               platform: visiblePlatforms[index],
  //               username: usernames[visiblePlatforms[index++]]),
  //           (index >= visiblePlatforms.length)
  //               ? Text("")
  //               : createSMButton(
  //                   platform: visiblePlatforms[index],
  //                   username:
  //                       usernames[visiblePlatforms[index++]],
  //                 ),
  //           (index >= visiblePlatforms.length)
  //               ? Text("")
  //               : createSMButton(
  //                   platform: visiblePlatforms[index],
  //                   username:
  //                       usernames[visiblePlatforms[index++]],
  //                 ),
  //         ]);
  //       },
  //       itemCount: (visiblePlatforms.length / 3).ceil(),

//   // display popup with user profile and social media links
//   static dynamic showUserProfilePopup(BuildContext context,
//       {String UID}) async {
//     // get list of all visible platforms
//     DatabaseService databaseService = new DatabaseService(
//         UIDIn: Provider.of<User>(context, listen: false).uid);
//     List<String> visiblePlatforms =
//         await databaseService.getEnabledPlatformsList(UID);
//     // get list of profile usernames
//     Map<String, dynamic> usernames =
//         await databaseService.getUserProfileNames(UID);
//     String fullName = await databaseService.getFullName(UID);
//     bool isFriendAdded = await databaseService.isFriendAdded(UID);
//     String profilePhotoURL = await databaseService.getPhotoURL(UID);
//     // increment variable for use with scrolling SM buttons (use instead of i)
//     int index = 0;

//     showDialog(
//         barrierColor: Colors.grey[500].withOpacity(.25),
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//               backgroundColor: Colors.grey[700],
//               contentPadding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                   side: BorderSide(color: Colors.cyan[600], width: .4)),
//               content: StatefulBuilder(
//                   builder: (BuildContext context, StateSetter setState) {
//                 return Container(
//                   height: 370.0,
//                   width: 250.0,
//                   // child: Column(children: [
//                   //   Row(children: [
//                       // Padding(
//                       //   padding: const EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 5.0),
//                       //   child: CircleAvatar(
//                       //       backgroundImage: NetworkImage(profilePhotoURL),
//                       //       radius: 30.0),
//                       // ),
//                   //     Column(
//                   //       children: [
//                   //         Text(
//                   //           fullName,
//                   //           style: TextStyle(
//                   //               fontSize: 25.0,
//                   //               fontWeight: FontWeight.bold,
//                   //               color: Colors.cyan[600]),
//                   //         ),
//                   //         Text(
//                   //           "@" + usernames["Soshi"],
//                   //           style: TextStyle(
//                   //               fontSize: 10.0,
//                   //               color: Colors.cyan[600],
//                   //               fontStyle: FontStyle.italic),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ]),
  // Divider(color: Colors.cyan[600]),
  // Container(
  //   height: 230.0,
  //   width: 260.0,
  //   padding: EdgeInsets.only(top: 10.0),
  //   child: ListView.separated(
  //     separatorBuilder: (BuildContext context, int i) {
  //       return Padding(padding: EdgeInsets.all(10.0));
  //     },
  //     scrollDirection: Axis.vertical,
  //     itemBuilder: (BuildContext context, int i) {
  //       return Row(children: [
  //         createSMButton(
  //             platform: visiblePlatforms[index],
  //             username: usernames[visiblePlatforms[index++]]),
  //         (index >= visiblePlatforms.length)
  //             ? Text("")
  //             : createSMButton(
  //                 platform: visiblePlatforms[index],
  //                 username:
  //                     usernames[visiblePlatforms[index++]],
  //               ),
  //         (index >= visiblePlatforms.length)
  //             ? Text("")
  //             : createSMButton(
  //                 platform: visiblePlatforms[index],
  //                 username:
  //                     usernames[visiblePlatforms[index++]],
  //               ),
  //       ]);
  //     },
  //     itemCount: (visiblePlatforms.length / 3).ceil(),
  //   ),
  // ),
//                     ElevatedButton(
//                         onPressed: () {
//                           if (isFriendAdded) {
//                             // do nothing
//                           } else {
//                             // add friend, update button
//                             databaseService.addFriend(friendUID: UID);
//                             // reset index to avoid invalid index on refresh
//                             index = 0;
//                             setState(() {
//                               isFriendAdded = true;
//                             });
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                             primary: isFriendAdded
//                                 ? Colors.white
//                                 : Colors.cyan[600]),
//                         child: Container(
//                           width: 150.0,
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: (isFriendAdded)
//                                   ? [
//                                       Text(
//                                         "Connected",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black),
//                                       ),
//                                       Padding(
//                                           padding: EdgeInsets.only(left: 5.0)),
//                                       Icon(
//                                         Icons.verified_user,
//                                         color: Colors.green,
//                                       )
//                                     ]
//                                   : [
//                                       Text(
//                                         "Connect",
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black),
//                                       ),
//                                       Padding(
//                                           padding: EdgeInsets.only(left: 5.0)),
//                                       Icon(
//                                         Icons.add,
//                                         color: Colors.black,
//                                       )
//                                     ]),
//                         )),
//                   ]),
//                 );
//               }));
//         });
//   }
}
