import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('toMap() with empty options', () {
    const options = CustomTabsOptions();
    expect(options.toMap(), <String, dynamic>{});
  });

  test('toMap() with full options', () {
    const options = CustomTabsOptions(
      toolbarColor: Color(0xFFFFEBEE),
      urlBarHidingEnabled: true,
      shareState: CustomTabsShareState.off,
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
      headers: {'key': 'value'},
      bottomSheetConfiguration: CustomTabsBottomSheetConfiguration(
        initialHeight: 500,
        activityHeightResizeBehavior:
            CustomTabsActivityHeightResizeBehavior.adjustable,
        cornerRadius: 16,
      ),
    );

    expect(options.toMap(), <String, dynamic>{
      'toolbarColor': '#ffffebee',
      'urlBarHidingEnabled': true,
      'shareState': 2,
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
      'headers': <String, String>{'key': 'value'},
      'bottomSheet': <String, dynamic>{
        'initialHeightDp': 500,
        'activityHeightResizeBehavior': 1,
        'cornerRadiusDp': 16,
      },
    });
  });

  test('CustomTabsCloseButtonPosition.rawValue return associated value', () {
    expect(CustomTabsCloseButtonPosition.start.rawValue, 1);
    expect(CustomTabsCloseButtonPosition.end.rawValue, 2);
  });

  test('CustomTabsShareState.rawValue return associated value', () {
    expect(CustomTabsShareState.browserDefault.rawValue, 0);
    expect(CustomTabsShareState.on.rawValue, 1);
    expect(CustomTabsShareState.off.rawValue, 2);
  });

  test(
      'CustomTabsActivityHeightResizeBehavior.rawValue return associated value',
      () {
    expect(CustomTabsActivityHeightResizeBehavior.defaultBehavior.rawValue, 0);
    expect(CustomTabsActivityHeightResizeBehavior.adjustable.rawValue, 1);
    expect(CustomTabsActivityHeightResizeBehavior.fixed.rawValue, 2);
  });
}
