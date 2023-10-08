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
      colorSchemes: CustomTabsColorSchemes(
        colorScheme: CustomTabsColorScheme.system,
        lightParams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFEBAA),
          navigationBarColor: Color(0xFFFFEBAB),
          navigationBarDividerColor: Color(0xFFFFEBAC),
        ),
        darkParams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFEBBA),
          navigationBarColor: Color(0xFFFFEBBB),
          navigationBarDividerColor: Color(0xFFFFEBBC),
        ),
        defaultPrams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFEBCA),
          navigationBarColor: Color(0xFFFFEBCB),
          navigationBarDividerColor: Color(0xFFFFEBCC),
        ),
      ),
      urlBarHidingEnabled: true,
      shareState: CustomTabsShareState.off,
      showPageTitle: true,
      instantAppsEnabled: false,
      closeButton: CustomTabsCloseButton(
        icon: "icon",
        position: CustomTabsCloseButtonPosition.end,
      ),
      animations: CustomTabsAnimations(
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
      'colorSchemes': <String, dynamic>{
        'colorScheme': 0,
        'lightColorSchemeParams': <String, String>{
          'toolbarColor': '#ffffebaa',
          'navigationBarColor': '#ffffebab',
          'navigationBarDividerColor': '#ffffebac',
        },
        'darkColorSchemeParams': <String, String>{
          'toolbarColor': '#ffffebba',
          'navigationBarColor': '#ffffebbb',
          'navigationBarDividerColor': '#ffffebbc',
        },
        'defaultColorSchemeParams': {
          'toolbarColor': '#ffffebca',
          'navigationBarColor': '#ffffebcb',
          'navigationBarDividerColor': '#ffffebcc',
        },
      },
      'urlBarHidingEnabled': true,
      'shareState': 2,
      'showPageTitle': true,
      'instantAppsEnabled': false,
      'closeButtonIcon': "icon",
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

  test('CustomTabsColorScheme.rawValue return associated value', () {
    expect(CustomTabsColorScheme.system.rawValue, 0);
    expect(CustomTabsColorScheme.light.rawValue, 1);
    expect(CustomTabsColorScheme.dark.rawValue, 2);
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
