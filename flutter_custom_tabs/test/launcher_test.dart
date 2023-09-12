import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mock = _MockCustomTabsPlatform();
  setUp(() => {CustomTabsPlatform.instance = mock});

  test('launch: with null options', () async {
    const url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    await launch(url);

    verify(mock.launch(url));
  });

  test('launch: with empty options', () async {
    const url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    const customTabsOptions = CustomTabsOptions();
    const safariVCOptions = SafariViewControllerOptions();
    await launch(
      url,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    );

    verify(mock.launch(
      url,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    ));
  });

  test('launch: with empty options', () async {
    const url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    const customTabsOptions = CustomTabsOptions(
      toolbarColor: Color(0xFFFFEBEE),
      urlBarHidingEnabled: true,
      shareState: CustomTabsShareState.off,
      showPageTitle: true,
      enableInstantApps: false,
      animation: CustomTabsAnimation(
        startEnter: '_startEnter',
        startExit: '_startExit',
        endEnter: '_endEnter',
        endExit: '_endExit',
      ),
      extraCustomTabs: <String>[
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
    );
    const safariVCOptions = SafariViewControllerOptions(
      preferredBarTintColor: Color(0xFFFFEBEE),
      preferredControlTintColor: Color(0xFFFFFFFF),
      barCollapsingEnabled: true,
      entersReaderIfAvailable: false,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      statusBarBrightness: Brightness.dark,
    );

    await launch(
      url,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    );

    verify(mock.launch(
      url,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    ));
  });

  test('launch: with a url containing a whitespace', () async {
    const url = ' http://example.com/';
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    await launch(url);

    verify(mock.launch(
      url.trimLeft(),
    ));
  });

  test('statusBarBrightness: run on iOS', () async {
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(binding.renderView.automaticSystemUiAdjustment, isTrue);

    const url = 'http://example.com/';
    final launchResult = launch(
      url,
      safariVCOptions: const SafariViewControllerOptions(
        statusBarBrightness: Brightness.dark,
      ),
    );

    expect(binding.renderView.automaticSystemUiAdjustment, isFalse);
    await launchResult;
    expect(binding.renderView.automaticSystemUiAdjustment, isTrue);
  });

  test('statusBarBrightness: run on non-iOS', () async {
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(binding.renderView.automaticSystemUiAdjustment, true);

    const url = 'http://example.com/';
    final launchResult = launch(
      url,
      safariVCOptions: const SafariViewControllerOptions(
        statusBarBrightness: Brightness.dark,
      ),
    );

    expect(binding.renderView.automaticSystemUiAdjustment, isTrue);
    await launchResult;
    expect(binding.renderView.automaticSystemUiAdjustment, isTrue);
  });

  test('closeAllIfPossible', () async {
    when(mock.closeAllIfPossible()).thenAnswer((_) async {});

    await closeAllIfPossible();

    verify(mock.closeAllIfPossible());
  });
}

class _MockCustomTabsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CustomTabsPlatform {
  @override
  Future<void> launch(
    String? urlString, {
    CustomTabsOptions? customTabsOptions,
    SafariViewControllerOptions? safariVCOptions,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #launch,
        [urlString],
        <Symbol, Object?>{
          #customTabsOptions: customTabsOptions,
          #safariVCOptions: safariVCOptions
        },
      ),
      returnValue: Future.value(null),
    );
  }

  @override
  Future<void> closeAllIfPossible() async {
    return super.noSuchMethod(
      Invocation.method(
        #closeAllIfPossible,
        {},
      ),
      returnValue: Future.value(null),
    );
  }
}
