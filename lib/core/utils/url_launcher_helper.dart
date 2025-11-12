import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  /// Launch any URL safely
  static Future<void> launchUrlLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
