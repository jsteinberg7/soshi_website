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
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  /*
  Methods pertaining to getting user data
  */

  Future<dynamic> getUserFile(String soshiUsername) {
    return usersCollection.doc(soshiUsername).get().then((DocumentSnapshot ds) {
      Map data = ds.data() as Map;
      return data;
    });
  }

  // pass in soshiUsername, return map of user switches (platform visibility)
  Map<String, dynamic> getUserSwitches(Map userData) {
    return userData["Switches"];
  }

  // return list of enabled user switches
  Future<List<String>> getEnabledPlatformsList(Map userData) async {
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
  Future<String> getUsernameForPlatform({required Map userData, required String platform}) async {
    String username;
    Map<String, dynamic> profileNamesMap = getUserProfileNames(userData);
    username = profileNamesMap[platform];
    return username;
  }

  // pass in soshiUsername, return (Map) of full name of user
  Map<String, dynamic> getFullNameMap(Map userData) {
    return userData["Name"];
  }

  // pass in soshiUsername, return (String) full name of user
  String getFullName(Map userData) {
    Map fullNameMap = getFullNameMap(userData);
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
    return userData["Bio"];
  }

  List getFriends(Map userData) {
    return userData["Friends"];
  }

  bool isVerified(Map userData) {
    if (userData["is_verified"] == null || userData["is_verified"] == false) {
      return false;
    } else {
      return true;
    }
  }

  int getFriendsCount(Map userData) {
    List<dynamic> friendsList = getFriends(userData);
    int friendsCount = friendsList.length;
    return friendsCount;
  }
}
