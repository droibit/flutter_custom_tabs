import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsOptions', () {
    test('toMap() returns empty map when option values are null', () {
      const options = CustomTabsOptions();
      expect(options.toMap(), <String, dynamic>{});
    });

    test('toMap() returns a map with complete options', () {
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
        showTitle: true,
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
        browser: CustomTabsBrowserConfiguration(
          prefersDefaultBrowser: false,
          fallbackCustomTabs: [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
          headers: {'key': 'value'},
        ),
        partial: PartialCustomTabsConfiguration(
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
        'showTitle': true,
        'instantAppsEnabled': false,
        'closeButton': <String, dynamic>{
          'icon': "icon",
          'position': 2,
        },
        'animations': <String, String>{
          'startEnter': '_startEnter',
          'startExit': '_startExit',
          'endEnter': '_endEnter',
          'endExit': '_endExit',
        },
        'browser': {
          'prefersDefaultBrowser': false,
          'fallbackCustomTabs': [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
          'headers': {'key': 'value'},
        },
        'partial': <String, dynamic>{
          'initialHeightDp': 500,
          'activityHeightResizeBehavior': 1,
          'cornerRadiusDp': 16,
        },
      });
    });
  });

  test('CustomTabsShareState returns associated value', () {
    expect(CustomTabsShareState.browserDefault.rawValue, 0);
    expect(CustomTabsShareState.on.rawValue, 1);
    expect(CustomTabsShareState.off.rawValue, 2);
  });
}
