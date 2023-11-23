import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SheetPresentationControllerConfiguration', () {
    test('toMap() returns a map with complete options', () {
      const configuration = SheetPresentationControllerConfiguration(
        detents: {SheetPresentationControllerDetent.large},
        largestUndimmedDetentIdentifier:
            SheetPresentationControllerDetent.medium,
        prefersScrollingExpandsWhenScrolledToEdge: true,
        prefersGrabberVisible: false,
        prefersEdgeAttachedInCompactHeight: true,
        preferredCornerRadius: 8.0,
      );
      expect(configuration.toMap(), <String, dynamic>{
        'detents': ['large'],
        'largestUndimmedDetentIdentifier': 'medium',
        'prefersScrollingExpandsWhenScrolledToEdge': true,
        'prefersGrabberVisible': false,
        'prefersEdgeAttachedInCompactHeight': true,
        'preferredCornerRadius': 8.0,
      });
    });

    test('toMap() returns expected result with default values', () {
      const configuration = SheetPresentationControllerConfiguration(
        detents: {SheetPresentationControllerDetent.large},
      );
      expect(configuration.toMap(), <String, dynamic>{
        'detents': ['large'],
      });
    });
  });

  test('SheetPresentationControllerDetent returns associated value', () {
    expect(SheetPresentationControllerDetent.large.rawValue, 'large');
    expect(SheetPresentationControllerDetent.medium.rawValue, 'medium');
  });
}
