import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs/src/custom_tabs_launcher.dart';
import 'package:flutter_custom_tabs/src/custom_tabs_option.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel =
      MethodChannel('com.github.droibit.flutter.plugins.custom_tabs');
  late List<MethodCall> log;

  channel.setMockMethodCallHandler((methodCall) async => log.add(methodCall));
  setUp(() {
    log = <MethodCall>[];
  });

  test('customTabLauncher() called method "launch"', () async {
    await customTabsLauncher(
        'http://example.com/',
        const CustomTabsOption(
          enableUrlBarHiding: true,
        ),
        const SafariViewControllerOption(barCollapsingEnabled: false));
    expect(
      log,
      <Matcher>[
        isMethodCall('launch', arguments: <String, dynamic>{
          'url': 'http://example.com/',
          'customTabsOption': const <String, dynamic>{
            'enableUrlBarHiding': true,
          },
          'safariVCOption': const <String, dynamic>{
            'barCollapsingEnabled': false
          }
        }),
      ],
    );
  });
}
