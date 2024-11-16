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
  });

  test('closeAllIfPossible() invoke method "closeAllIfPossible"', () async {
    await customTabs.closeAllIfPossible();
    expect(api.closeAllIfPossibleCalled, isTrue);
  });
}

class _MockCustomTabsApi implements CustomTabsApi {
  String? url;
  bool? prefersDeepLink;
  PlatformOptions? options;
  String? sessionId;
  bool launchUrlCalled = false;
  bool closeAllIfPossibleCalled = false;
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
