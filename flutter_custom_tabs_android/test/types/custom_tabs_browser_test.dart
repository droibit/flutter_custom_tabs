import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

import '../messages.dart';

void main() {
  test('toMessage() returns empty map when option values are null', () {
    const configuration = CustomTabsBrowserConfiguration();
    final actual = configuration.toMessage();
    expect(actual.prefersDefaultBrowser, isNull);
    expect(actual.fallbackCustomTabs, isNull);
    expect(actual.headers, isNull);
  });

  test('toMessage() returns a map with complete options', () {
    const configuration = CustomTabsBrowserConfiguration(
      prefersDefaultBrowser: true,
      fallbackCustomTabs: [
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
      headers: {'key': 'value'},
    );
    final actual = configuration.toMessage();
    expect(actual.prefersDefaultBrowser, configuration.prefersDefaultBrowser);
    expect(actual.fallbackCustomTabs, configuration.fallbackCustomTabs);
    expect(actual.headers, configuration.headers);
  });
}
