class User {
  String fullName = "";
  Map<String, dynamic> usernames = {};
  List<String> visiblePlatforms = [];
  String photoURL = "";

  User(
      {required String fullName,
      required Map<String, dynamic> usernames,
      required List<String> visiblePlatforms,
      required String photoURL}) {
    this.fullName = fullName;
    this.usernames = usernames;
    this.visiblePlatforms = visiblePlatforms;
    this.photoURL = photoURL;
  }
}
