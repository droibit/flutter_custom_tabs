import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _MockCustomTabsApi api;
  late CustomTabsPluginAndroid customTabs;

  setUp(() {
    api = _MockCustomTabsApi();
    customTabs = CustomTabsPluginAndroid(api: api);
  });

  test('registerWith() registers instance', () {
    CustomTabsPluginAndroid.registerWith();
    expect(CustomTabsPlatform.instance, isA<CustomTabsPluginAndroid>());
  });

  test('launch() invoke method "launch" with valid options', () async {
    const url = 'http://example.com/';
    const prefersDeepLink = true;
    const options = CustomTabsOptions(
      urlBarHidingEnabled: true,
    );
    api.setLaunchExpectations(
      url: url,
      prefersDeepLink: prefersDeepLink,
      options: options,
    );

    await customTabs.launch(
      url,
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: options,
      safariVCOptions: const _Options(),
    );
  });

  test('launch() invoke method "launch" with invalid options', () async {
    const url = 'http://example.com/';
    const prefersDeepLink = true;
    const options = _Options(
      urlBarHidingEnabled: true,
    );
    api.setLaunchExpectations(
      url: url,
      prefersDeepLink: prefersDeepLink,
      options: options,
    );

    await customTabs.launch(
      url,
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: options,
      safariVCOptions: const _Options(),
    );
  });

  test('launch() invoke method "launch" with no options', () async {
    const url = 'http://example.com/';
    const prefersDeepLink = true;
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
  bool launchUrlCalled = false;
  bool closeAllIfPossibleCalled = false;

  void setLaunchExpectations({
    required String url,
    bool? prefersDeepLink,
    PlatformOptions? options,
  }) {
    this.url = url;
    this.prefersDeepLink = prefersDeepLink;
    this.options = options;
  }

  @override
  Future<void> launch(
    String url, {
    required bool prefersDeepLink,
    Map<String?, Object?>? options,
  }) async {
    expect(url, this.url);
    expect(prefersDeepLink, this.prefersDeepLink);

    if (this.options == null) {
      expect(options, isNull);
    } else if (this.options is CustomTabsOptions) {
      final expected = (this.options as CustomTabsOptions).toMessage();
      expect(options?['urlBarHidingEnabled'], expected['urlBarHidingEnabled']);
    } else {
      expect(options, isNotNull);
    }
    launchUrlCalled = true;
  }

  @override
  Future<void> closeAllIfPossible() async {
    closeAllIfPossibleCalled = true;
  }
}

class _Options implements PlatformOptions {
  final bool? urlBarHidingEnabled;

  const _Options({
    this.urlBarHidingEnabled,
  });
}
