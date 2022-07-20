import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:seeip_client/seeip_client.dart';

abstract class Analytics {
  static FirebaseAnalytics instance = FirebaseAnalytics.instance;

  static Future<void> setUserAttributes({required String userId}) async {
    await instance.setUserId(id: userId);
    // await instance.setUserProperty(name: 'location', value: SeeipClient().getGeoIP().toString());
  }

  static logSignIn(String method) async {
    await instance.logLogin(loginMethod: method);
  }

  static logSignUp(String method) async {
    await instance.logSignUp(signUpMethod: method);
  }

  static Future<void> logQRScan(String qrResult) async {
    await instance.logEvent(name: 'qr_scan', parameters: {
      'qr_result': qrResult,
    });
  }

  static Future<void> logSuccessfulQRScan(String qrResult) async {
    await instance.logEvent(
        name: "successful_qr_scan",
        parameters: {"scanned_username": qrResult.split("/").last});
  }

  static Future<void> logFailedQRScan(String qrResult) async {
    await instance
        .logEvent(name: "failed_qr_scan", parameters: {"qr_result": qrResult});
  }

  static Future<void> logAddFriend(String friendUsername) async {
    await instance.logEvent(
        name: "add_friend", parameters: {"friend_username": friendUsername});
  }

  static Future<void> logRemoveFriend(String friendUsername) {
    return instance.logEvent(
        name: "remove_friend", parameters: {"friend_username": friendUsername});
  }

  static Future<void> logCopyLinkToClipboard() {
    return instance.logEvent(name: "copied_link_to_clipboard");
  }

  static Future<void> logUpdateUsernameForPlatform(
      String username, String platform) {
    return instance.logEvent(
        name: "update_username_for_platform",
        parameters: {"username": username, "platform": platform});
  }

  static Future<void> logAccessPlatform(String platform) async {
    await instance
        .logEvent(name: "access_platform", parameters: {"platform": platform});
  }
}
