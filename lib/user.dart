class User {
  String fullName;
  Map<String, dynamic> usernames;
  List<String> visiblePlatforms;
  String photoURL;
  String soshiUsername;
  String userBio;
  int friendsAdded;
  Map platformMetaData;

  User(
      {required this.fullName,
      required this.usernames,
      required this.visiblePlatforms,
      required this.photoURL,
      required this.soshiUsername,
      required this.userBio,
      required this.friendsAdded,
      required this.platformMetaData});
}
