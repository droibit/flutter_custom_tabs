import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns associated value', () {
    expect(CustomTabsShareState.browserDefault.rawValue, 0);
    expect(CustomTabsShareState.on.rawValue, 1);
    expect(CustomTabsShareState.off.rawValue, 2);
  });
}
