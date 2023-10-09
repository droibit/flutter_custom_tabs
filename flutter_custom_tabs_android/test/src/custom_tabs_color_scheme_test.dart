import 'package:flutter/foundation.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toColorScheme() returns light color scheme', () {
    expect(Brightness.light.toColorScheme(), CustomTabsColorScheme.light);
  });

  test('toColorScheme() returns dark color scheme', () {
    expect(Brightness.dark.toColorScheme(), CustomTabsColorScheme.dark);
  });
}
