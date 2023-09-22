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
    final url = Uri.parse('http://example.com/');
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    await launchUrl(url);

    verify(mock.launch(url.toString()));
  });

  test('launch: with empty options', () async {
    final url = Uri.parse('http://example.com/');
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    const customTabsOptions = CustomTabsOptions();
    const safariVCOptions = SafariViewControllerOptions();
    await launchUrl(
      url,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    );

    verify(mock.launch(
      url.toString(),
      prefersDeepLink: false,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    ));
  });

  test('launch: with full options', () async {
    final url = Uri.parse('http://example.com/');
    when(mock.launch(
      any,
      prefersDeepLink: anyNamed('prefersDeepLink'),
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    const customTabsOptions = CustomTabsOptions(
      colorSchemes: CustomTabsColorSchemes(
        defaultPrams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFEBEE),
        ),
      ),
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
    );
    const prefersDeepLink = true;
    await launchUrl(
      url,
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    );

    verify(mock.launch(
      url.toString(),
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    ));
  });

  test('launchUrlString: with a url containing a whitespace', () async {
    const url = ' http://example.com/';
    when(mock.launch(
      any,
      customTabsOptions: anyNamed('customTabsOptions'),
      safariVCOptions: anyNamed('safariVCOptions'),
    )).thenAnswer((_) async {});

    await launchUrlString(url);

    verify(mock.launch(url.trimLeft()));
  });

  test('closeCustomTabs', () async {
    when(mock.closeAllIfPossible()).thenAnswer((_) async {});

    await closeCustomTabs();

    verify(mock.closeAllIfPossible());
  });
}

class _MockCustomTabsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CustomTabsPlatform {
  @override
  Future<void> launch(
    String? urlString, {
    bool? prefersDeepLink = false,
    CustomTabsOptions? customTabsOptions,
    SafariViewControllerOptions? safariVCOptions,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #launch,
        [urlString],
        <Symbol, Object?>{
          #prefersDeepLink: prefersDeepLink,
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
