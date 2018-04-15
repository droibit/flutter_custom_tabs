import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart'
    show CustomTabsOption;
import 'package:flutter_custom_tabs/src/custom_tabs_launcher.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  const channel =
      const MethodChannel('com.github.droibit.flutter.plugins.custom_tabs');

  final log = <MethodCall>[];
  channel.setMockMethodCallHandler((methodCall) async => log.add(methodCall));

  tearDown(() => log.clear());

  test('customTabLauncher() no options', () async {
    await customTabsLauncher('http://example.com/', const CustomTabsOption());
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'options': const <String, dynamic>{},
        }),
      ],
    );
  });

  test('customTabLauncher() contains options', () async {
    await customTabsLauncher(
      'http://example.com/',
      const CustomTabsOption(
        toolbarColor: const Color(0xFFFFEBEE),
        enableUrlBarHiding: true,
        enableDefaultShare: false,
        showPageTitle: true,
      ),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'options': const <String, dynamic>{
            'toolbarColor': '#ffffebee',
            'enableUrlBarHiding': true,
            'enableDefaultShare': false,
            'showPageTitle': true,
          },
        }),
      ],
    );
  });
}
