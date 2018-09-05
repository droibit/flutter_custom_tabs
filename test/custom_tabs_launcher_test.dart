import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/src/custom_tabs_launcher.dart';
import 'package:flutter_custom_tabs/src/custom_tabs_option.dart';
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
          'option': const <String, dynamic>{},
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
        enableInstantApps: false,
        animation: const CustomTabsAnimation(
          startEnter: '_startEnter',
          startExit: '_startExit',
          endEnter: '_endEnter',
          endExit: '_endExit',
        ),
        extraCustomTabs: <String>[
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
    );
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'option': const <String, dynamic>{
            'toolbarColor': '#ffffebee',
            'enableUrlBarHiding': true,
            'enableDefaultShare': false,
            'showPageTitle': true,
            'enableInstantApps': false,
            'animations': <String, String>{
              'startEnter': '_startEnter',
              'startExit': '_startExit',
              'endEnter': '_endEnter',
              'endExit': '_endExit',
            },
            'extraCustomTabs': <String>[
              'org.mozilla.firefox',
              'com.microsoft.emmx',
            ],
          },
        }),
      ],
    );
  });
}
