import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_custom_tabs_ios/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SheetPresentationControllerConfiguration', () {
    test('toMessage() returns expected message with default values', () {
      const configuration = SheetPresentationControllerConfiguration(
        detents: {SheetPresentationControllerDetent.large},
      );
      final actual = configuration.toMessage();
      expect(
        actual.detents,
        containsAll([configuration.detents.first.rawValue]),
      );
      expect(actual.largestUndimmedDetentIdentifier, isNull);
      expect(actual.prefersScrollingExpandsWhenScrolledToEdge, isNull);
      expect(actual.prefersGrabberVisible, isNull);
      expect(actual.prefersEdgeAttachedInCompactHeight, isNull);
      expect(actual.preferredCornerRadius, isNull);
    });

    test('toMessage() returns a message with complete options', () {
      const configuration = SheetPresentationControllerConfiguration(
        detents: {SheetPresentationControllerDetent.large},
        largestUndimmedDetentIdentifier:
            SheetPresentationControllerDetent.medium,
        prefersScrollingExpandsWhenScrolledToEdge: true,
        prefersGrabberVisible: false,
        prefersEdgeAttachedInCompactHeight: true,
        preferredCornerRadius: 8.0,
      );

      final actual = configuration.toMessage();
      expect(
        actual.detents,
        containsAll([configuration.detents.first.rawValue]),
      );
      expect(
        actual.largestUndimmedDetentIdentifier,
        configuration.largestUndimmedDetentIdentifier!.rawValue,
      );
      expect(
        actual.prefersScrollingExpandsWhenScrolledToEdge,
        configuration.prefersScrollingExpandsWhenScrolledToEdge,
      );
      expect(actual.prefersGrabberVisible, configuration.prefersGrabberVisible);
      expect(
        actual.prefersEdgeAttachedInCompactHeight,
        configuration.prefersEdgeAttachedInCompactHeight,
      );
      expect(actual.preferredCornerRadius, configuration.preferredCornerRadius);
    });
  });

  group('SheetPresentationControllerDetent', () {
    test('rawValue returns associated value', () {
      expect(SheetPresentationControllerDetent.large.rawValue, 'large');
      expect(SheetPresentationControllerDetent.medium.rawValue, 'medium');
    });
  });
}
