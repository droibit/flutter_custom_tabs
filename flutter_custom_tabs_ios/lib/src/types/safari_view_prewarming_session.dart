import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:meta/meta.dart';

/// The session for the prewarming of [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller).
@immutable
class SafariViewPrewarmingSession implements PlatformSession {
  const SafariViewPrewarmingSession(this.id);

  final String? id;

  @override
  String toString() => 'SafariViewPrewarmingSession: $id';
}
