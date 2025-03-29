import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUrlLauncherPlugin extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlugin {
  @override
  Future<bool> canLaunch(String url) {
    throw UnimplementedError();
  }

  @override
  Future<void> closeWebView() {
    throw UnimplementedError();
  }

  @override
  Future<bool> launch(
    String? url, {
    bool? useSafariVC = false,
    bool? useWebView = false,
    bool? enableJavaScript = false,
    bool? enableDomStorage = false,
    bool? universalLinksOnly = false,
    Map<String, String>? headers = const <String, String>{},
    String? webOnlyWindowName,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#launch, [
        url
      ], {
        #useSafariVC: useSafariVC,
        #useWebView: useWebView,
        #enableJavaScript: enableJavaScript,
        #enableDomStorage: enableDomStorage,
        #universalLinksOnly: universalLinksOnly,
        #headers: headers,
        #webOnlyWindowName: webOnlyWindowName
      }),
      returnValue: Future.value(false),
    );
  }

  @override
  LinkDelegate get linkDelegate => throw UnimplementedError();

  @override
  bool openNewWindow(String url, {String? webOnlyWindowName}) {
    throw UnimplementedError();
  }
}
