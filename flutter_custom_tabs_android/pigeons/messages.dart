import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  kotlinOut: 'android/src/main/java/com/github/droibit/flutter/plugins/customtabs/Messages.kt',
  kotlinOptions: KotlinOptions(
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

  String? warmup(Map<String, Object?>? options);

  void mayLaunch(
    List<String?> urls, String sessionPackageName);

  void invalidate(String sessionPackageName);
}
