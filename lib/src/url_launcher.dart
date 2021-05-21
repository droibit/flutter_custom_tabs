import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'custom_tabs_option.dart';

Future<void> urlLauncher(String urlString, CustomTabsOption option) {
  return launch(urlString, forceSafariVC: true, forceWebView: false);
}
