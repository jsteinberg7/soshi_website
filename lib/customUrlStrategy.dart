import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Uses the browser URL's pathname to represent Flutter's route name.
///
/// In order to use [CustomUrlStrategy] for an app, it needs to be set like this:
///
/// ```dart
/// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
///
/// // Somewhere before calling `runApp()` do:
/// setUrlStrategy(PathUrlStrategy());
/// ```
class CustomUrlStrategy extends HashUrlStrategy {
  /// Creates an instance of [CustomUrlStrategy].
  ///
  /// The [PlatformLocation] parameter is useful for testing to mock out browser
  /// interactions.
  PlatformLocation _platformLocation = const BrowserPlatformLocation();
  CustomUrlStrategy([
    PlatformLocation _platformLocation = const BrowserPlatformLocation(),
  ])  : _basePath = stripTrailingSlash(extractPathname(checkBaseHref(
          _platformLocation.getBaseHref(),
        ))),
        super(_platformLocation);

  final String _basePath;

  // @override
  // String getPath() {
  //   print("GETTING PATH");
  //   final String path = _platformLocation.pathname + _platformLocation.search;
  //   print("PATH: " + path);
  //   if (_basePath.isNotEmpty && path.startsWith(_basePath)) {
  //     return ensureLeadingSlash(path.substring(_basePath.length));
  //   }
  //   return ensureLeadingSlash(path);
  // }

  @override
  String getPath() {
    // the hash value is always prefixed with a `#`
    // and if it is empty then it will stay empty
    final String path = _platformLocation.hash;
    assert(path.isEmpty || path.startsWith('#'));

    // We don't want to return an empty string as a path. Instead we default to "/".
    if (path.isEmpty || path == '#') {
      return '/';
    }
    // At this point, we know [path] starts with "#" and isn't empty.
    return path.substring(1);
  }

  // @override
  // String prepareExternalUrl(String internalUrl) {
  //   print("PREPARING EXTERNAL URL");
  //   print("INTERAL URL: $internalUrl");
  //   if (internalUrl.isNotEmpty && !internalUrl.startsWith('/')) {
  //     internalUrl = '/$internalUrl';
  //   }
  //   return '$_basePath$internalUrl';
  // }

  @override
  String prepareExternalUrl(String internalUrl) {
    // It's convention that if the hash path is empty, we omit the `#`; however,
    // if the empty URL is pushed it won't replace any existing fragment. So
    // when the hash path is empty, we instead return the location's path and
    // query.
    return internalUrl.isEmpty
        ? '${_platformLocation.pathname}${_platformLocation.search}'
        // : '$internalUrl';
        : '#$internalUrl';
  }
}
