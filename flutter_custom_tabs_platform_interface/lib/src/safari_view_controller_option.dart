import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// Option class for customizing appearance of Safari View Controller.
/// **This option applies only on iOS platform.**
///
/// See also:
///
/// * [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
///
@immutable
class SafariViewControllerOption {
  const SafariViewControllerOption({
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
enum SafariViewControllerDismissButtonStyle { done, close, cancel }

extension SafariViewControllerDismissButtonStyleRawValue
    on SafariViewControllerDismissButtonStyle {
  @visibleForTesting
  int get rawValue {
    switch (this) {
      case SafariViewControllerDismissButtonStyle.done:
        return 0;
      case SafariViewControllerDismissButtonStyle.close:
        return 1;
      case SafariViewControllerDismissButtonStyle.cancel:
        return 2;
    }
  }
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
  automatic,

  /// A presentation style that indicates no adaptations should be made.
  none,

  /// A presentation style in which the presented view covers the screen.
  fullScreen,

  /// A presentation style that partially covers the underlying content.
  pageSheet,

  /// A presentation style that displays the content centered in the screen.
  formSheet,

  /// A view presentation style in which the presented view covers the screen.
  overFullScreen
}

extension ViewControllerModalPresentationStyleRawValue
    on ViewControllerModalPresentationStyle {
  @visibleForTesting
  int get rawValue {
    switch (this) {
      case ViewControllerModalPresentationStyle.automatic:
        return -2;
      case ViewControllerModalPresentationStyle.none:
        return -1;
      case ViewControllerModalPresentationStyle.fullScreen:
        return 0;
      case ViewControllerModalPresentationStyle.pageSheet:
        return 1;
      case ViewControllerModalPresentationStyle.formSheet:
        return 2;
      case ViewControllerModalPresentationStyle.overFullScreen:
        return 5;
    }
  }
}
