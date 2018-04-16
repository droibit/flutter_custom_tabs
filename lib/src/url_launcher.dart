import 'dart:async';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart'
    show CustomTabsOption;
import 'package:url_launcher/url_launcher.dart' as u;

Future<void> urlLauncher(String urlString, CustomTabsOption option) {
  return u.launch(urlString, forceSafariVC: true, forceWebView: false);
}
