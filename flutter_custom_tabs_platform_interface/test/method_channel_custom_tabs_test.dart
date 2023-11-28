import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_custom_tabs_platform_interface/src/method_channel_custom_tabs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> log;
  late MethodChannelCustomTabs customTabs;

  const channel =
      MethodChannel('plugins.flutter.droibit.github.io/custom_tabs');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          channel, (methodCall) async => log.add(methodCall));

  setUp(() {
    log = <MethodCall>[];
    customTabs = MethodChannelCustomTabs();
  });

  test('launch() invoke method "launch" with null options', () async {
    await customTabs.launch('http://example.com/');
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'prefersDeepLink': false,
          'customTabsOptions': const <String, dynamic>{},
          'safariVCOptions': const <String, dynamic>{}
        }),
      ],
    );
  });

  test('launch() invoke method "launch" with options', () async {
    await customTabs.launch(
      'http://example.com/',
      prefersDeepLink: true,
      customTabsOptions: _Options(),
      safariVCOptions: _Options(),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'prefersDeepLink': true,
          'customTabsOptions': const <String, dynamic>{},
          'safariVCOptions': const <String, dynamic>{},
        }),
      ],
    );
  });

  test('closeAllIfPossible() invoke method "closeAllIfPossible"', () async {
    await customTabs.closeAllIfPossible();
    expect(
      log,
      <Matcher>[
        isMethodCall('closeAllIfPossible', arguments: null),
      ],
    );
  });
}

class _Options implements PlatformOptions {}
