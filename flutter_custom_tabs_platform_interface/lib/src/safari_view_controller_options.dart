import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// Options class for customizing appearance of Safari View Controller.
/// **This options applied only on iOS platform.**
///
/// See also:
///
/// * [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
///
@immutable
class SafariViewControllerOptions {
  const SafariViewControllerOptions({
    this.preferredBarTintColor,
    this.preferredControlTintColor,
    this.barCollapsingEnabled,
    this.entersReaderIfAvailable,
    this.dismissButtonStyle,
    this.modalPresentationStyle,
    this.pageSheetConfiguration,
  });

  /// Availability: iOS15.0+
  const SafariViewControllerOptions.pageSheet({
    required SheetPresentationControllerConfiguration? configuration,
    Color? preferredBarTintColor,
    Color? preferredControlTintColor,
    bool? entersReaderIfAvailable,
    SafariViewControllerDismissButtonStyle? dismissButtonStyle,
  }) : this(
          preferredBarTintColor: preferredBarTintColor,
          preferredControlTintColor: preferredControlTintColor,
          entersReaderIfAvailable: entersReaderIfAvailable,
          dismissButtonStyle: dismissButtonStyle,
          modalPresentationStyle:
              ViewControllerModalPresentationStyle.pageSheet,
          pageSheetConfiguration: configuration,
        );

  /// The color to tint the background of the navigation bar and the toolbar.
  /// - Availability: iOS10.0+
  final Color? preferredBarTintColor;

  /// The color to tint the control buttons on the navigation bar and the toolbar.
  /// - Availability: iOS10.0+
  final Color? preferredControlTintColor;

  /// If enabled, collapses the toolbar when the user scrolls down the page.
  /// - Availability: iOS11.0+
  final bool? barCollapsingEnabled;

  /// A value that specifies whether Safari should enter Reader mode, if it is available.
  /// - Availability: iOS11.0+
  final bool? entersReaderIfAvailable;

  /// Dismiss button style on the navigation bar.
  /// - Availability: iOS11.0+
  final SafariViewControllerDismissButtonStyle? dismissButtonStyle;

  /// The presentation style for modal view controllers.
  final ViewControllerModalPresentationStyle? modalPresentationStyle;

  /// The bottom sheet configuration.
  final SheetPresentationControllerConfiguration? pageSheetConfiguration;

  /// Converts the [SafariViewControllerOptions] instance into a [Map] instance for serialization.
  Map<String, dynamic> toMap() {
    final dest = <String, dynamic>{};
    if (preferredBarTintColor != null) {
      dest['preferredBarTintColor'] =
          '#${preferredBarTintColor!.value.toRadixString(16)}';
    }
    if (preferredControlTintColor != null) {
      dest['preferredControlTintColor'] =
          '#${preferredControlTintColor!.value.toRadixString(16)}';
    }
    if (barCollapsingEnabled != null) {
      dest['barCollapsingEnabled'] = barCollapsingEnabled;
    }
    if (entersReaderIfAvailable != null) {
      dest['entersReaderIfAvailable'] = entersReaderIfAvailable;
    }
    if (modalPresentationStyle != null) {
      dest['modalPresentationStyle'] = modalPresentationStyle!.rawValue;
    }
    if (dismissButtonStyle != null) {
      dest['dismissButtonStyle'] = dismissButtonStyle!.rawValue;
    }
    if (pageSheetConfiguration != null) {
      dest['pageSheet'] = pageSheetConfiguration!.toMap();
    }
    return dest;
  }
}

/// Dismiss button style on the navigation bar of SafariViewController.
///
/// See also:
///
/// * [SFSafariViewController.DismissButtonStyle](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/dismissbuttonstyle)
///
enum SafariViewControllerDismissButtonStyle {
  done(0),
  close(1),
  cancel(2);

  @internal
  const SafariViewControllerDismissButtonStyle(this.rawValue);

  @internal
  final int rawValue;
}

/// A view presentation style in which the presented view covers the screen.
///
/// See also:
///
/// * [UIModalPresentationStyle](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle)
///
enum ViewControllerModalPresentationStyle {
  /// The default presentation style chosen by the system.
  /// - Availability: iOS13.0+
  automatic(-2),

  /// A presentation style that indicates no adaptations should be made.
  none(-1),

  /// A presentation style in which the presented view covers the screen.
  fullScreen(0),

  /// A presentation style that partially covers the underlying content.
  pageSheet(1),

  /// A presentation style that displays the content centered in the screen.
  formSheet(2),

  /// A view presentation style in which the presented view covers the screen.
  overFullScreen(5);

  @internal
  const ViewControllerModalPresentationStyle(this.rawValue);

  @internal
  final int rawValue;
}

/// The configuration to show SFSafariViewController as a bottom sheet.
///
/// - Availability: iOS15.0+
///
/// See also:
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

  /// The corner radius that the sheet attempts to present with.
  final double? preferredCornerRadius;

  @internal
  Map<String, dynamic> toMap() {
    final dest = <String, dynamic>{
      'detents': detents.map((e) => e.rawValue).toList(),
    };
    if (largestUndimmedDetentIdentifier != null) {
      dest['largestUndimmedDetentIdentifier'] =
          largestUndimmedDetentIdentifier!.rawValue;
    }
    if (prefersScrollingExpandsWhenScrolledToEdge != null) {
      dest['prefersScrollingExpandsWhenScrolledToEdge'] =
          prefersScrollingExpandsWhenScrolledToEdge;
    }
    if (prefersGrabberVisible != null) {
      dest['prefersGrabberVisible'] = prefersGrabberVisible;
    }
    if (prefersEdgeAttachedInCompactHeight != null) {
      dest['prefersEdgeAttachedInCompactHeight'] =
          prefersEdgeAttachedInCompactHeight;
    }
    if (preferredCornerRadius != null) {
      dest['preferredCornerRadius'] = preferredCornerRadius;
    }
    return dest;
  }
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
