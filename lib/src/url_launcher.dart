import 'dart:async';

import 'package:url_launcher/url_launcher.dart' as u;

Future<void> urlLauncher(String urlString) {
  return u.launch(urlString, forceSafariVC: true);
}
