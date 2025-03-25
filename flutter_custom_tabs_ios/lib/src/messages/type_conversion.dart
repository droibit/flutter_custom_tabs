import 'messages.g.dart';
import '../types/types.dart';

extension SafariViewControllerOptionsConverter on SafariViewControllerOptions {
  SFSafariViewControllerOptions toMessage() {
    // Temporarily suppress deprecation warnings until migration to `Color.toARGB32`.
    // See: https://github.com/flutter/flutter/issues/160184#issuecomment-2560184639
    return SFSafariViewControllerOptions(
      // ignore: deprecated_member_use
      preferredBarTintColor: preferredBarTintColor?.value,
      // ignore: deprecated_member_use
      preferredControlTintColor: preferredControlTintColor?.value,
      barCollapsingEnabled: barCollapsingEnabled,
      entersReaderIfAvailable: entersReaderIfAvailable,
      dismissButtonStyle: dismissButtonStyle?.rawValue,
      modalPresentationStyle: modalPresentationStyle?.rawValue,
      pageSheet: pageSheet?.toMessage(),
    );
  }
}

extension SheetPresentationControllerConfigurationConverter
    on SheetPresentationControllerConfiguration {
  UISheetPresentationControllerConfiguration toMessage() {
    return UISheetPresentationControllerConfiguration(
      detents: detents.map((e) => e.rawValue).toList(),
      largestUndimmedDetentIdentifier:
          largestUndimmedDetentIdentifier?.rawValue,
      prefersScrollingExpandsWhenScrolledToEdge:
          prefersScrollingExpandsWhenScrolledToEdge,
      prefersGrabberVisible: prefersGrabberVisible,
      prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
      preferredCornerRadius: preferredCornerRadius,
    );
  }
}
