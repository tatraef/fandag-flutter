import 'package:url_launcher/url_launcher.dart';

/// Thin wrapper around url_launcher for phone calls and external links.
abstract class Launcher {
  /// Opens the dialer with [phone]. Returns whether the launch succeeded.
  static Future<bool> call(String phone) {
    final String sanitized = phone.replaceAll(RegExp(r'[^\d+]'), '');

    return _launch(Uri(scheme: 'tel', path: sanitized));
  }

  /// Opens [url] in an external application (browser / Telegram).
  static Future<bool> openExternal(String url) {
    return _launch(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  static Future<bool> _launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: mode);
    }

    return false;
  }
}
