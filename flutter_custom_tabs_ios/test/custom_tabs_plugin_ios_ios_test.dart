import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_custom_tabs_ios/src/messages/messages.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _MockCustomTabsApi api;
  late CustomTabsPluginIOS customTabs;

  setUp(() {
    api = _MockCustomTabsApi();
    customTabs = CustomTabsPluginIOS(api: api);
  });

  test('registerWith() registers instance', () {
    CustomTabsPluginIOS.registerWith();
    expect(CustomTabsPlatform.instance, isA<CustomTabsPluginIOS>());
  });

  test('launch() invoke method "launch" with valid options', () async {
    const url = 'http://example.com/';
    const prefersDeepLink = true;
    const options = SafariViewControllerOptions(
      barCollapsingEnabled: true,
    );
    api.setLaunchExpectations(
      url: url,
      prefersDeepLink: prefersDeepLink,
      options: options,
    );

    await customTabs.launch(
      url,
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: const _Options(),
      safariVCOptions: options,
    );
    expect(api.launchUrlCalled, isTrue);
  });

  test('launch() invoke method "launch" with invalid options', () async {
    const url = 'http://example.com/';
    const prefersDeepLink = false;
    const options = _Options(
      barCollapsingEnabled: true,
    );
    api.setLaunchExpectations(
      url: url,
      prefersDeepLink: prefersDeepLink,
      options: options,
    );
    await customTabs.launch(
      url,
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: const _Options(),
      safariVCOptions: options,
    );
    expect(api.launchUrlCalled, isTrue);
  });

  test('launch() invoke method "launch" with no options', () async {
    const url = 'http://example.com/';
    const prefersDeepLink = false;
    api.setLaunchExpectations(
      url: url,
      prefersDeepLink: prefersDeepLink,
    );
    await customTabs.launch(
      url,
      prefersDeepLink: prefersDeepLink,
    );
    expect(api.launchUrlCalled, isTrue);
  });

  test('closeAllIfPossible() invoke method "closeAllIfPossible"', () async {
    await customTabs.closeAllIfPossible();
    expect(api.closeAllIfPossibleCalled, isTrue);
  });

  test('mayLaunch() invoke method "mayLaunch" with valid options', () async {
    const urls = ['http://example.com/'];
    const sessionId = 'test-session-id';
    api.setMayLaunchExpectations(
      urls: urls,
      sessionId: sessionId,
    );

    final session = await customTabs.mayLaunch(urls);
    expect(
      session,
      isA<SafariViewPrewarmingSession>().having((s) => s.id, 'id', sessionId),
    );
    expect(api.mayLaunchCalled, isTrue);
  });

  test('invalidate() invoke method "invalidate" with valid options', () async {
    const sessionId = 'test-session-id';
    api.setInvalidateExpectations(
      sessionId: sessionId,
    );

    const session = SafariViewPrewarmingSession(sessionId);
    await customTabs.invalidate(session);
    expect(api.invalidateCalled, isTrue);
  });

  test(
      'invalidate() throws ArgumentError if session is not SafariViewPrewarmingSession',
      () async {
    expect(
      () => customTabs.invalidate(_Session()),
      throwsA(
        isA<ArgumentError>(),
      ),
    );
  });

  test('invalidate() does nothing when session is NoSession', () async {
    await customTabs.invalidate(const SafariViewPrewarmingSession(null));
    expect(api.invalidateCalled, isFalse);
  });
}

class _MockCustomTabsApi extends CustomTabsApi {
  String? url;
  bool? prefersDeepLink;
  PlatformOptions? options;
  String? sessionId;
  List<String?>? urls;
  bool launchUrlCalled = false;
  bool closeAllIfPossibleCalled = false;
  bool mayLaunchCalled = false;
  bool invalidateCalled = false;

  void setLaunchExpectations({
    required String url,
    bool? prefersDeepLink,
    PlatformOptions? options,
  }) {
    this.url = url;
    this.prefersDeepLink = prefersDeepLink;
    this.options = options;
  }

  void setMayLaunchExpectations({
    required List<String?> urls,
    required String sessionId,
  }) {
    this.urls = urls;
    this.sessionId = sessionId;
  }

  void setInvalidateExpectations({
    required String sessionId,
  }) {
    this.sessionId = sessionId;
  }

  @override
  Future<void> launch(
    String url, {
    required bool prefersDeepLink,
    SFSafariViewControllerOptions? options,
  }) async {
    expect(url, this.url);
    expect(prefersDeepLink, this.prefersDeepLink);

    if (this.options == null) {
      expect(options, isNull);
    } else if (this.options is SafariViewControllerOptions) {
      final expected =
          (this.options as SafariViewControllerOptions).toMessage();
      expect(options?.barCollapsingEnabled, expected.barCollapsingEnabled);
    } else {
      expect(options, isNotNull);
    }
    launchUrlCalled = true;
  }

  @override
  Future<void> closeAllIfPossible() async {
    closeAllIfPossibleCalled = true;
  }

  @override
  Future<String?> mayLaunch(List<String?> urls) async {
    expect(urls, this.urls);
    mayLaunchCalled = true;
    return sessionId;
  }

  @override
  Future<void> invalidate(String sessionId) async {
    expect(this.sessionId, sessionId);
    invalidateCalled = true;
  }
}

class _Options implements PlatformOptions {
  final bool? barCollapsingEnabled;

  const _Options({
    this.barCollapsingEnabled,
  });
}

class _Session implements PlatformSession {}
