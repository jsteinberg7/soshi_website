import 'package:url_launcher/url_launcher.dart';

// Basic wrapper for url services (all methods are static)
abstract class URL {
  // open browser to specified url target
  static void launchURL(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  // return custom url for platform and username
  // note: some platforms use a system not invloving usernames
  // (Linkedin, Faceboook, etc. use a numbering system)
  static String getPlatformURL(
      {required String platform, required String username}) {
    if (platform == "Instagram") {
      return "https://www.instagram.com/" + username + "/?hl=en";
    } else if (platform == "Snapchat") {
      return "https://www.snapchat.com/add/" + username;
    } else if (platform == "Twitter") {
      return "https://mobile.twitter.com/" + username;
    } else if (platform == "Linkedin") {
      return username;
    } else if (platform == "Facebook") {
      return username;
    }
    // to make compiler happy
    return "";
    // insta snapchat twitter linkedin facebook
  }
}
