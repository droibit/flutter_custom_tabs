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

  test('launch: with null option', () async {
    const url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async {});

    await launch(url);

    verify(mock.launch(url));
  });

  test('launch: with empty option', () async {
    const url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async {});

    const customTabsOption = CustomTabsOption();
    const safariVCOption = SafariViewControllerOption();
    await launch(
      url,
      customTabsOption: customTabsOption,
      safariVCOption: safariVCOption,
    );

    verify(mock.launch(
      url,
      customTabsOption: customTabsOption,
      safariVCOption: safariVCOption,
    ));
  });

  test('launch: with empty option', () async {
    const url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async {});

    const customTabsOption = CustomTabsOption(
      toolbarColor: Color(0xFFFFEBEE),
      enableUrlBarHiding: true,
      enableDefaultShare: false,
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
    const safariVCOption = SafariViewControllerOption(
      preferredBarTintColor: Color(0xFFFFEBEE),
      preferredControlTintColor: Color(0xFFFFFFFF),
      barCollapsingEnabled: true,
      entersReaderIfAvailable: false,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      statusBarBrightness: Brightness.dark,
    );

    await launch(
      url,
      customTabsOption: customTabsOption,
      safariVCOption: safariVCOption,
    );

    verify(mock.launch(
      url,
      customTabsOption: customTabsOption,
      safariVCOption: safariVCOption,
    ));
  });

  test('launch: with a url containg a whitespace', () async {
    const url = ' http://example.com/';
    when(mock.launch(
      any,
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async {});

    await launch(url);

    verify(mock.launch(
      url.trimLeft(),
    ));
  });

  test('statusBarBrightness: run on iOS', () async {
    when(mock.launch(
      any,
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async {});

    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(binding.renderView.automaticSystemUiAdjustment, isTrue);

    const url = 'http://example.com/';
    final launchResult = launch(
      url,
      safariVCOption: const SafariViewControllerOption(
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
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async {});

    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(binding.renderView.automaticSystemUiAdjustment, true);

    const url = 'http://example.com/';
    final launchResult = launch(
      url,
      safariVCOption: const SafariViewControllerOption(
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
    CustomTabsOption? customTabsOption,
    SafariViewControllerOption? safariVCOption,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #launch,
        [urlString],
        <Symbol, Object?>{
          #customTabsOption: customTabsOption,
          #safariVCOption: safariVCOption
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
