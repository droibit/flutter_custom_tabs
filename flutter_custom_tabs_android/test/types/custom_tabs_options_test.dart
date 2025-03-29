import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsOptions', () {
    test('toMessage() returns empty message when option values are null', () {
      const options = CustomTabsOptions();
      final actual = options.toMessage();
      expect(actual, isEmpty);
    });

    test('toMessage() returns a message with complete options', () {
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
        downloadButtonEnabled: true,
        bookmarksButtonEnabled: false,
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

      final actual = options.toMessage();
      expect(actual, <String, Object>{
        'colorSchemes': {
          'colorScheme': 0,
          'lightParams': {
            'toolbarColor': '#ffffebaa',
            'navigationBarColor': '#ffffebab',
            'navigationBarDividerColor': '#ffffebac',
          },
          'darkParams': {
            'toolbarColor': '#ffffebba',
            'navigationBarColor': '#ffffebbb',
            'navigationBarDividerColor': '#ffffebbc',
          },
          'defaultParams': {
            'toolbarColor': '#ffffebca',
            'navigationBarColor': '#ffffebcb',
            'navigationBarDividerColor': '#ffffebcc',
          },
        },
        'urlBarHidingEnabled': true,
        'shareState': 2,
        'showTitle': true,
        'instantAppsEnabled': false,
        'downloadButtonEnabled': true,
        'bookmarksButtonEnabled': false,
        'closeButton': {
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
        'partial': <String, Object>{
          'initialHeight': 500,
          'activityHeightResizeBehavior': 1,
          'cornerRadius': 16,
        },
      });
    });

    test('toMessage() returns a message with external browser options', () {
      final options = CustomTabsOptions.externalBrowser(headers: const {
        'key': 'value',
      });

      final actual = options.toMessage();
      expect(actual, <String, Object>{
        'browser': <String, Object>{
          'prefersExternalBrowser': true,
          'headers': {'key': 'value'},
        },
      });
    });
  });
}
