import 'messages.g.dart';
import '../types/types.dart';

extension SafariViewControllerOptionsConverter on SafariViewControllerOptions {
  SFSafariViewControllerOptions toMessage() {
    return SFSafariViewControllerOptions(
      preferredBarTintColor: preferredBarTintColor?.value,
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
