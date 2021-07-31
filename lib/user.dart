class User {
  String fullName = "";
  Map<String, dynamic> usernames = {};
  List<String> visiblePlatforms = [];
  User(
      {required String fullName,
      required Map<String, dynamic> usernames,
      required List<String> visiblePlatforms}) {
    this.fullName = fullName;
    this.usernames = usernames;
    this.visiblePlatforms = visiblePlatforms;
  }
}
