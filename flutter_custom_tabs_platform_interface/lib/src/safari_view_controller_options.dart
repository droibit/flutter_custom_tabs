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
    this.statusBarBrightness,
  });

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

  /// A value that specifies the status bar brightness of the application after opening a link.
  final Brightness? statusBarBrightness;

  @internal
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