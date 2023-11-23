import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_custom_tabs_platform_interface/src/method_channel_custom_tabs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('$CustomTabsPlatform() is the default instance', () {
    expect(
        CustomTabsPlatform.instance, isInstanceOf<MethodChannelCustomTabs>());
  });

  test('Cannot be implemented with `implements`', () {
    expect(() {
      CustomTabsPlatform.instance = _ImplementsCustomTabsPlatform();
    }, throwsA(isInstanceOf<AssertionError>()));
  });

  test('Can be mocked with `implements`', () {
    final mock = _CustomTabsPlatformMock();
    CustomTabsPlatform.instance = mock;
  });

  test('Can be extended', () {
    CustomTabsPlatform.instance = _CustomTabsPlatformMock();
  });
}

class _CustomTabsPlatformMock extends Mock
    with MockPlatformInterfaceMixin
    implements CustomTabsPlatform {}

class _ImplementsCustomTabsPlatform extends Mock
    implements CustomTabsPlatform {}
