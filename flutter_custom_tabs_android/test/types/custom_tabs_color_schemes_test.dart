import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsColorSchemes', () {
    test('toMap() returns empty map when option values are null', () {
      const schemes = CustomTabsColorSchemes();
      expect(schemes.toMap(), <String, dynamic>{});
    });

    test('toMap() returns a map with complete options', () {
      const schemes = CustomTabsColorSchemes(
        colorScheme: CustomTabsColorScheme.system,
        lightParams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFDBAA),
          navigationBarColor: Color(0xFFFFDBAB),
          navigationBarDividerColor: Color(0xFFFFDBAC),
        ),
        darkParams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFDBBA),
          navigationBarColor: Color(0xFFFFDBBB),
          navigationBarDividerColor: Color(0xFFFFDBBC),
        ),
        defaultPrams: CustomTabsColorSchemeParams(
          toolbarColor: Color(0xFFFFDBCA),
          navigationBarColor: Color(0xFFFFDBCB),
          navigationBarDividerColor: Color(0xFFFFDBCC),
        ),
      );
      expect(schemes.toMap(), <String, dynamic>{
        'colorScheme': 0,
        'lightColorSchemeParams': <String, String>{
          'toolbarColor': '#ffffdbaa',
          'navigationBarColor': '#ffffdbab',
          'navigationBarDividerColor': '#ffffdbac',
        },
        'darkColorSchemeParams': <String, String>{
          'toolbarColor': '#ffffdbba',
          'navigationBarColor': '#ffffdbbb',
          'navigationBarDividerColor': '#ffffdbbc',
        },
        'defaultColorSchemeParams': {
          'toolbarColor': '#ffffdbca',
          'navigationBarColor': '#ffffdbcb',
          'navigationBarDividerColor': '#ffffdbcc',
        },
      });
    });
  });

  group('CustomTabsColorSchemeParams', () {
    test('toMap() returns empty map when option values are null', () {
      const params = CustomTabsColorSchemeParams();
      expect(params.toMap(), <String, dynamic>{});
    });

    test('toMap() returns a map with complete options', () {
      const params = CustomTabsColorSchemeParams(
        toolbarColor: Color(0xFFFFCBAA),
        navigationBarColor: Color(0xFFFFCBAB),
        navigationBarDividerColor: Color(0xFFFFCBAC),
      );
      expect(params.toMap(), <String, dynamic>{
        'toolbarColor': '#ffffcbaa',
        'navigationBarColor': '#ffffcbab',
        'navigationBarDividerColor': '#ffffcbac',
      });
    });
  });

  group('CustomTabsColorScheme', () {
    test('returns associated value', () {
      expect(CustomTabsColorScheme.system.rawValue, 0);
      expect(CustomTabsColorScheme.light.rawValue, 1);
      expect(CustomTabsColorScheme.dark.rawValue, 2);
    });
  });

  group('BrightnessToColorScheme', () {
    test('toColorScheme() returns light color scheme', () {
      expect(Brightness.light.toColorScheme(), CustomTabsColorScheme.light);
    });

    test('toColorScheme() returns dark color scheme', () {
      expect(Brightness.dark.toColorScheme(), CustomTabsColorScheme.dark);
    });
  });
}
