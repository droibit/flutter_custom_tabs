import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('back: gets the resource ID of build-in back arrow button icon', () {
    expect(CustomTabsCloseButtonIcon.back, 'fct_ic_arrow_back');
  });
}
