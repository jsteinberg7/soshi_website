import 'package:cloud_firestore/cloud_firestore.dart';

/*
 Includes getters and setters for various fields in the Firebase database
 */
class DatabaseService {
  // soshiUsername of user
  String soshiUsername = "";

  // Basic constructor
  DatabaseService({required String soshiUsernameIn}) {
    soshiUsername = soshiUsernameIn;
  }

  // store reference to all user files
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  /*
  Methods pertaining to getting user data
  */

  Future<dynamic> getUserFile(String soshiUsername) {
    return usersCollection.doc(soshiUsername).get().then((DocumentSnapshot ds) {
      Map data = ds.data() as Map;
      return data;
    });
  }

  int getSoshiPoints(Map userData) {
    return userData["Soshi Points"] ?? 0;
  }

  List<dynamic> getPassions(Map userData) {
    List<dynamic> rawPassions = userData["passions"] ?? [];
    if (rawPassions.isEmpty) {
      return [];
    }
    List<int> indicesToRemove = [];
    for (int i = 0; i < 3; i++) {
      if (rawPassions[i].toString().contains("valid")) {
        indicesToRemove.add(i);
        //rawPassions.removeAt(i);
        print(rawPassions);
      }
    }
    for (int j = 0; j < indicesToRemove.length; j++) {
      rawPassions.removeAt(indicesToRemove[j]);
    }
    return rawPassions;
  }

  // pass in soshiUsername, return map of user switches (platform visibility)
  Map<String, dynamic> getUserSwitches(Map userData) {
    return userData["Switches"];
  }

  // return list of enabled user switches
  List<String> getEnabledPlatformsList(Map userData) {
    Map<String, dynamic> platformsMap = getUserSwitches(userData);

    List<String> enabledPlatformsList = [];
    // add all enabled platforms to platformsList
    platformsMap.forEach((platform, state) {
      if (state == true) {
        enabledPlatformsList.add(platform);
      }
    });

    return enabledPlatformsList;
  }

  // pass in soshiUsername, return (Map) of user profile names
  Map<String, dynamic> getUserProfileNames(Map userData) {
    return userData["Usernames"];
  }

  // return username for specified platform
  Future<String> getUsernameForPlatform(
      {required Map userData, required String platform}) async {
    String username;
    Map<String, dynamic> profileNamesMap = getUserProfileNames(userData);
    username = profileNamesMap[platform];
    return username;
  }

  // pass in soshiUsername, return (Map) of full name of user
  Map<String, dynamic> getFullNameMap(Map userData) {
    return userData["Name"] ?? {};
  }

  // pass in soshiUsername, return (String) full name of user
  String getFullName(Map userData) {
    Map fullNameMap = getFullNameMap(userData);
    if (fullNameMap.isEmpty) {
      return "";
    }
    // convert to String
    String fullName = fullNameMap["First"] + " " + fullNameMap["Last"];
    return fullName;
  }

  String getPhotoURL(Map userData) {
    return userData["Photo URL"];
  }

  Future<List<dynamic>> getProfilePlatforms() async {
    dynamic data;
    await usersCollection.doc(soshiUsername).get().then((DocumentSnapshot ds) {
      data = ds.data();
    });
    return data["Profile Platforms"];
  }

//get first name of Display Name
  Future<String> getFirstDisplayName(Map userData) async {
    String firstName;
    Map<String, dynamic> fullNameMap = getFullNameMap(userData);
    firstName = fullNameMap["First"];
    return firstName;
  }

  String getLastDisplayName(Map userData) {
    String lastName;
    Map<String, dynamic> fullName = getFullNameMap(userData);
    lastName = fullName["Last"];

    // await usersCollection.doc(soshiUsername).get().then(
    //     (DocumentSnapshot ds) => lastDisplayName = ds.data()["Name"]["Last"]);
    return lastName;
  }

  String getBio(Map userData) {
    return userData["Bio"] ?? "";
  }

  List getFriends(Map userData) {
    return userData["Friends"] ?? [];
  }

  int getFriendsCount(Map userData) {
    List<dynamic> friendsList = getFriends(userData);
    int friendsCount = friendsList.length;
    return friendsCount;
  }

  bool getVerifiedStatus(Map userData) {
    return userData["Verified"] ?? false;
    // if (isVerified == null) {
    //   isVerified == false;
    // }
  }

  Future<void> updateVerifiedStatus(String soshiUser, bool isVerified) async {
    await usersCollection.doc(soshiUser).update({"Verified": isVerified});
  }
}
