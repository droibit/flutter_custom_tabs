import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('toMap() with empty option', () {
    const options = CustomTabsOptions();
    expect(options.toMap(), <String, dynamic>{});
  });

  test('toMap() with full option', () {
    const options = CustomTabsOptions(
      toolbarColor: Color(0xFFFFEBEE),
      urlBarHidingEnabled: true,
      enableDefaultShare: false,
      showPageTitle: true,
      enableInstantApps: false,
      closeButtonPosition: CustomTabsCloseButtonPosition.end,
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

    expect(options.toMap(), <String, dynamic>{
      'toolbarColor': '#ffffebee',
      'urlBarHidingEnabled': true,
      'enableDefaultShare': false,
      'showPageTitle': true,
      'enableInstantApps': false,
      'closeButtonPosition': 2,
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
    });
  });

  test('CustomTabsCloseButtonPosition.rawValue return associated value', () {
    expect(CustomTabsCloseButtonPosition.start.rawValue, 1);
    expect(CustomTabsCloseButtonPosition.end.rawValue, 2);
  });
}
