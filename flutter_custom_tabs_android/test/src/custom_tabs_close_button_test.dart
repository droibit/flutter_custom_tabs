import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('back: get the resource identifier of build-in back button icon', () {
    expect(CustomTabsCloseButtonIcon.back, 'fct_ic_arrow_back');
  });
}
