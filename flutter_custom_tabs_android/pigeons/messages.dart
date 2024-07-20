import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  javaOut:
      'android/src/main/java/com/github/droibit/flutter/plugins/customtabs/Messages.java',
  javaOptions: JavaOptions(
    className: 'Messages',
    package: 'com.github.droibit.flutter.plugins.customtabs',
  ),
  dartOut: 'lib/src/messages/messages.g.dart',
))
@HostApi()
abstract class CustomTabsApi {
  void launch(
    String urlString, {
    required bool prefersDeepLink,
    Map<String, Object?>? options,
  });

  void closeAllIfPossible();
}
