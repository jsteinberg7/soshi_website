import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

/*
 Includes getters and setters for various fields in the Firebase database
 */
class DatabaseService {
  // UID of user
  String UID = "";

  // Basic constructor
  DatabaseService({required String UID}) {
    this.UID = UID;
  }

  // store reference to all user files
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  /*
  Methods pertaining to getting user data
  */

  // pass in UID, return map of user switches (platform visibility)
  Future<Map<String, dynamic>> getUserSwitches() async {
    Map<String, dynamic> switchMap = {};
    await usersCollection.doc(UID).get().then((DocumentSnapshot ds) {
      Map data = ds.data() as Map;
      switchMap = data["Switches"];
    });
    return switchMap;
  }

  // return list of enabled user switches
  Future<List<String>> getEnabledPlatformsList() async {
    Map<String, dynamic> platformsMap = await getUserSwitches();

    List<String> enabledPlatformsList = [];
    // add all enabled platforms to platformsList
    platformsMap.forEach((platform, state) {
      if (state == true) {
        enabledPlatformsList.add(platform);
      }
    });
    return enabledPlatformsList;
  }

  // pass in UID, return (Map) of user profile names
  Future<Map<String, dynamic>> getUserProfileNames() async {
    Map<String, dynamic> profileNamesMap = {};
    await usersCollection.doc(UID).get().then((DocumentSnapshot ds) {
      Map data = ds.data() as Map;
      profileNamesMap = data["Usernames"];
    });
    return profileNamesMap;
  }

  // return username for specified platform
  Future<String> getUsernameForPlatform({required String platform}) async {
    String username;
    Map<String, dynamic> profileNamesMap = await getUserProfileNames();
    username = profileNamesMap[platform];
    return username;
  }

  // pass in UID, return (Map) of full name of user
  Future<Map<String, dynamic>> getFullNameMap() async {
    Map<String, dynamic> fullNameMap = {};
    await usersCollection.doc(UID).get().then((DocumentSnapshot ds) {
      Map data = ds.data() as Map;
      fullNameMap = data["Name"];
    });
    return fullNameMap;
  }

  // pass in UID, return (String) full name of user
  Future<String> getFullName() async {
    Map<String, dynamic> fullNameMap;
    String fullName;
    fullNameMap = await getFullNameMap();
    // convert to String
    fullName = fullNameMap["First"] + " " + fullNameMap["Last"];
    return fullName;
  }

  Future<String> getPhotoURL(String UID) async {
    dynamic data;
    await usersCollection.doc(UID).get().then((DocumentSnapshot ds) {
      data = ds.data();
    });
    return data["Photo URL"];
  }

// UV functions

//get first name of Display Name
  Future<String> getFirstDisplayName() async {
    String firstName;
    Map<String, dynamic> fullNameMap = await getFullNameMap();
    firstName = fullNameMap["First"];
    // await usersCollection.doc(UID).get().then((DocumentSnapshot ds) =>
    // firstDisplayName =
    // ds.data()["Name"]); //Do i have to access "Names" first?
    return firstName;
  }

  Future updateDisplayName({required String firstName}) async {
    String localFirstDisplayName = await getFirstDisplayName();
    String localLastDisplayName = await getLastDisplayName();
    // update local map to reflect change
    localFirstDisplayName = firstName;

    //usernamesMap[platform] = username;
    // update database to reflect local map change
    return await usersCollection.doc(UID).update({
      "Name": {"First": localFirstDisplayName, "Last": localLastDisplayName}
    });
  }

  Future<String> getLastDisplayName() async {
    String lastName;
    Map<String, dynamic> fullName = await getFullNameMap();
    lastName = fullName["Last"];

    return lastName;
  }

  Future updateLastDisplayName({required String lastName}) async {
    String localLastDisplayName = await getLastDisplayName();
    // update local map to reflect change
    localLastDisplayName = lastName;
    //usernamesMap[platform] = username;
    // update database to reflect local map change
    return await usersCollection
        .doc(UID)
        .update({"Last": localLastDisplayName});
  }
}
