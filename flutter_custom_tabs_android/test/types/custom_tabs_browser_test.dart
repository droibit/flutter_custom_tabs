import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toMap() returns a map with complete options', () {
    const configuration = CustomTabsBrowserConfiguration(
      prefersDefaultBrowser: true,
      fallbackCustomTabs: [
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
      headers: {'key': 'value'},
    );
    expect(configuration.toMap(), <String, dynamic>{
      'prefersDefaultBrowser': true,
      'fallbackCustomTabs': [
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
      'headers': {'key': 'value'},
    });
  });

  test('toMap() returns empty map when option values are null', () {
    const configuration = CustomTabsBrowserConfiguration();
    expect(configuration.toMap(), <String, dynamic>{});
  });
}
