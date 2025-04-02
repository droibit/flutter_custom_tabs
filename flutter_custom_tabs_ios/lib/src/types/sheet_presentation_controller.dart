import 'package:meta/meta.dart';

/// Configuration for presenting [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) as a customizable sheet.
///
/// This class provides control over iOS 15's `UISheetPresentationController`, enabling rich sheet-based
/// presentations with the following capabilities:
///
/// - **Customizable Height**: Configure the sheet to appear at different heights using [detents]
///   (medium: approximately half-screen, large: full-screen)
/// - **Interactive Resizing**: Users can resize the sheet by dragging when multiple detents are specified
/// - **Visual Indicators**: Control the visibility of the grabber handle with [prefersGrabberVisible]
/// - **Background Interaction**: Allow interaction with content behind the sheet when using
///   [largestUndimmedDetentIdentifier]
/// - **Appearance Control**: Customize corner radius and edge attachment behavior in different orientations
///
/// ### See also
/// - [UISheetPresentationController](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)
@immutable
class SheetPresentationControllerConfiguration {
  const SheetPresentationControllerConfiguration({
    required this.detents,
    this.largestUndimmedDetentIdentifier,
    this.prefersScrollingExpandsWhenScrolledToEdge,
    this.prefersGrabberVisible,
    this.prefersEdgeAttachedInCompactHeight,
    this.preferredCornerRadius,
  });

  /// The set of heights where a sheet can rest.
  final Set<SheetPresentationControllerDetent> detents;

  /// The largest detent that doesn’t dim the view underneath the sheet.
  final SheetPresentationControllerDetent? largestUndimmedDetentIdentifier;

  /// A Boolean value that determines whether scrolling expands the sheet to a larger detent.
  final bool? prefersScrollingExpandsWhenScrolledToEdge;

  /// A Boolean value that determines whether the sheet shows a grabber at the top.
  final bool? prefersGrabberVisible;

  /// A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class.
  final bool? prefersEdgeAttachedInCompactHeight;

  /// The corner radius in logical pixels that the sheet attempts to present with.
  final double? preferredCornerRadius;
}

/// An object that represents a height where a sheet naturally rests.
enum SheetPresentationControllerDetent {
  /// A system detent for a sheet at full height.
  large("large"),

  /// A system detent for a sheet that’s approximately half the height of the screen, and is inactive in compact height.
  medium("medium");

  @internal
  const SheetPresentationControllerDetent(this.rawValue);

  @internal
  final String rawValue;
}
