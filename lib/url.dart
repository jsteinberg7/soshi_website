import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

// Basic wrapper for url services (all methods are static)
abstract class URL {
  // open browser to specified url target
  static Future<void> launchURL(String url) async {
    await canLaunch(url)
        ? await launch(url, forceSafariVC: false)
        : throw 'Could not launch $url';
  }

  // return custom url for platform and username
  // note: some platforms use a system not invloving usernames
  // (Linkedin, Faceboook, etc. use a numbering system)
  static String getPlatformURL(
      {required String platform, required String username}) {
    if (platform == "SMS") {
      return "sms://$username";
    } else if (platform == "Phone") {
      return "sms://$username";
    } else if (platform == "Instagram") {
      return "https://www.instagram.com/" + username + "/?hl=en";
    } else if (platform == "Snapchat") {
      return "https://www.snapchat.com/add/" + username;
    } else if (platform == "Twitter") {
      return "https://mobile.twitter.com/" + username;
    } else if (platform == "Linkedin") {
      return username;
    } else if (platform == "Facebook") {
      return username;
    } else if (platform == "Reddit") {
      return "https://www.reddit.com/user/" + username + "/";
    } else if (platform == "Tiktok") {
      String tiktokLink;
      if (platform.contains("tiktok.com")) {
        username.contains("https://")
            ? tiktokLink = username
            : tiktokLink = "https://" + username;
      } else {
        tiktokLink = "https://www.tiktok.com/@" + username;
      }
      return tiktokLink;
    } else if (platform == "Discord") {
      return "https://discordapp.com/users/" + username + "/";
    } else if (platform == "Email") {
      return "mailto:" + username;
    } else if (platform == "Spotify") {
      return "https://open.spotify.com/user/" + username;
    } else if (platform == "Venmo") {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return "venmo://paycharge?txn=pay&recipients=" + username;
      } else {
        return "https://venmo.com/" + username;
      }
    } else if (platform == "Contact") {
      return username;
    } else if (platform == "Personal") {
      String personalLink;
      username.contains("https://")
          ? personalLink = username
          : personalLink = "https://" + username;
      return personalLink;
    } else if (platform == "Youtube") {
      String youtubeLink;
      username.contains("https://")
          ? youtubeLink = username
          : youtubeLink = "https://www.youtube.com/channel/" + username;
      return youtubeLink;
    }
    // to make compiler happy
    return "";
  }
}
