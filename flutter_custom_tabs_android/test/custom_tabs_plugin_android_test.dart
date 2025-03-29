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

  test('warmup() invoke method "warmup" with valid options', () async {
    const options = CustomTabsSessionOptions(
      prefersDefaultBrowser: true,
    );
    const packageName = 'com.example.browser';
    api.setWarmupExpectations(
      options: options,
      sessionPackageName: packageName,
    );

    final session = await customTabs.warmup(options);
    expect(
      session,
      isA<CustomTabsSession>()
          .having((s) => s.packageName, 'packageName', packageName),
    );
  });

  test('warmup() invoke method "warmup" with no options', () async {
    const packageName = 'com.example.browser';
    api.setWarmupExpectations(
      sessionPackageName: packageName,
    );

    final session = await customTabs.warmup();
    expect(
      session,
      isA<CustomTabsSession>()
          .having((s) => s.packageName, 'packageName', packageName),
    );
  });

  test('warmup() returns null when packageName is null', () async {
    final session = await customTabs.warmup();
    expect(session, isNull);
  });

  test(
      'warmup() throws ArgumentError when options is not CustomTabsSessionOptions',
      () async {
    expect(
      customTabs.warmup(const _Options()),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('mayLaunch() invoke method "mayLaunch" with valid session', () async {
    const urls = ['http://example.com/'];
    const packageName = 'com.example.browser';
    api.setMayLaunchExpectations(
      urls: urls,
      sessionPackageName: packageName,
    );

    const session = CustomTabsSession(packageName);
    await customTabs.mayLaunch(
      urls,
      session: session,
    );
    expect(api.mayLaunchCalled, isTrue);
  });

  test('mayLaunch() throws ArgumentError when session is not CustomTabsSession',
      () {
    expect(
      customTabs.mayLaunch(
        ['http://example.com/'],
        session: _Session(),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('mayLaunch() does nothing when session is NoSession', () async {
    await customTabs.mayLaunch(
      ['http://example.com/'],
      session: const CustomTabsSession(null),
    );
    expect(api.mayLaunchCalled, isFalse);
  });

  test('invalidate() invoke method "invalidate" with valid options', () async {
    const packageName = 'com.example.browser';
    api.setInvalidateExpectations(
      sessionPackageName: packageName,
    );

    await customTabs.invalidate(const CustomTabsSession(packageName));
    expect(api.invalidateCalled, isTrue);
  });

  test(
      'invalidate() throws ArgumentError when session is not CustomTabsSession',
      () {
    expect(
      () => customTabs.invalidate(_Session()),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('invalidate() does nothing when session is NoSession', () async {
    await customTabs.invalidate(const CustomTabsSession(null));
    expect(api.invalidateCalled, isFalse);
  });
}

class _MockCustomTabsApi extends CustomTabsApi {
  String? url;
  bool? prefersDeepLink;
  PlatformOptions? launchOptions;
  PlatformOptions? sessionOptions;
  String? sessionPackageName;
  List<String?>? urls;
  bool launchUrlCalled = false;
  bool closeAllIfPossibleCalled = false;
  bool warmupCalled = false;
  bool mayLaunchCalled = false;
  bool invalidateCalled = false;

  void setLaunchExpectations({
    required String url,
    bool? prefersDeepLink,
    PlatformOptions? options,
  }) {
    this.url = url;
    this.prefersDeepLink = prefersDeepLink;
    launchOptions = options;
  }

  void setWarmupExpectations({
    PlatformOptions? options,
    String? sessionPackageName,
  }) {
    this.sessionPackageName = sessionPackageName;
    sessionOptions = options;
  }

  void setInvalidateExpectations({
    required String sessionPackageName,
  }) {
    this.sessionPackageName = sessionPackageName;
  }

  void setMayLaunchExpectations({
    required List<String?> urls,
    required String sessionPackageName,
  }) {
    this.urls = urls;
    this.sessionPackageName = sessionPackageName;
  }

  @override
  Future<void> launch(
    String url, {
    required bool prefersDeepLink,
    Map<String?, Object?>? options,
  }) async {
    expect(url, this.url);
    expect(prefersDeepLink, this.prefersDeepLink);

    if (launchOptions == null) {
      expect(options, isNull);
    } else if (launchOptions is CustomTabsOptions) {
      final expected = (launchOptions as CustomTabsOptions).toMessage();
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

  @override
  Future<String?> warmup(Map<String?, Object?>? options) async {
    if (sessionOptions == null) {
      expect(options, isNull);
    } else if (sessionOptions is CustomTabsSessionOptions) {
      final expected = (sessionOptions as CustomTabsSessionOptions).toMessage();
      expect(
        options?['prefersDefaultBrowser'],
        expected['prefersDefaultBrowser'],
      );
    } else {
      expect(options, isNotNull);
    }
    warmupCalled = true;
    return sessionPackageName;
  }

  @override
  Future<void> mayLaunch(List<String?> urls, String sessionPackageName) async {
    expect(urls, this.urls);
    expect(sessionPackageName, this.sessionPackageName);
    mayLaunchCalled = true;
  }

  @override
  Future<void> invalidate(String sessionPackageName) async {
    expect(sessionPackageName, this.sessionPackageName);
    invalidateCalled = true;
  }
}

class _Options implements PlatformOptions {
  final bool? urlBarHidingEnabled;

  const _Options({
    this.urlBarHidingEnabled,
  });
}

class _Session implements PlatformSession {}
