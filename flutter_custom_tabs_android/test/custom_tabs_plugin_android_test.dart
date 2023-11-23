import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> log;
  late CustomTabsPluginAndroid customTabs;

  const channel =
      MethodChannel('plugins.flutter.droibit.github.io/custom_tabs');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    channel,
    (methodCall) async => log.add(methodCall),
  );

  setUp(() {
    log = <MethodCall>[];
    customTabs = CustomTabsPluginAndroid();
  });

  test('launch() invoke method "launch" with CustomTabsOptions', () async {
    await customTabs.launch(
      'http://example.com/',
      prefersDeepLink: true,
      customTabsOptions: const CustomTabsOptions(
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const _Options(),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'prefersDeepLink': true,
          'customTabsOptions': const <String, dynamic>{
            'urlBarHidingEnabled': true,
          },
        }),
      ],
    );
  });

  test('launch() invoke method "launch" with invalid options', () async {
    await customTabs.launch(
      'http://example.com/',
      prefersDeepLink: true,
      customTabsOptions: const _Options(
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const _Options(),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'prefersDeepLink': true,
          'customTabsOptions': const <String, dynamic>{},
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

class _Options implements PlatformOptions {
  final bool? urlBarHidingEnabled;

  const _Options({
    this.urlBarHidingEnabled,
  });

  @override
  Map<String, dynamic> toMap() => {
        if (urlBarHidingEnabled != null)
          'urlBarHidingEnabled': urlBarHidingEnabled,
      };
}
