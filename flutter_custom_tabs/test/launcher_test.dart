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

  test('launch with null option', () async {
    final url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async => null);

    await launch(url);

    verify(mock.launch(url));
  });

  test('launch with empty option', () async {
    final url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async => null);

    final customTabsOption = const CustomTabsOption();
    final safariVCOption = const SafariViewControllerOption();
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

  test('launch with empty option', () async {
    final url = 'http://example.com/';
    when(mock.launch(
      any,
      customTabsOption: anyNamed('customTabsOption'),
      safariVCOption: anyNamed('safariVCOption'),
    )).thenAnswer((_) async => null);

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
}
