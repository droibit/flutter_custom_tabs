import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:meta/meta.dart';

import 'sheet_presentation_controller.dart';

/// The comprehensive options
/// when launching [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) by specifying a URL.
///
/// See also:
/// - [SFSafariViewController.Configuration](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/configuration)
@immutable
class SafariViewControllerOptions implements PlatformOptions {
  /// Creates a [SafariViewControllerOptions] instance with the specified options.
  const SafariViewControllerOptions({
    this.preferredBarTintColor,
    this.preferredControlTintColor,
    this.barCollapsingEnabled,
    this.entersReaderIfAvailable,
    this.dismissButtonStyle,
    this.modalPresentationStyle,
    this.pageSheetConfiguration,
  });

  /// Creates a [SafariViewControllerOptions] instance with page sheet configuration.
  ///
  /// Availability: **iOS15.0+**
  const SafariViewControllerOptions.pageSheet({
    required SheetPresentationControllerConfiguration configuration,
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
  final Color? preferredBarTintColor;

  /// The color to tint the control buttons on the navigation bar and the toolbar.
  final Color? preferredControlTintColor;

  /// A Boolean value that enables the url bar to hide as the user scrolls down the page.
  final bool? barCollapsingEnabled;

  /// A Boolean value that specifies whether Safari should enter Reader mode, if it is available.
  final bool? entersReaderIfAvailable;

  /// Dismiss button style on the navigation bar.
  final SafariViewControllerDismissButtonStyle? dismissButtonStyle;

  /// The presentation style for modal view controllers.
  final ViewControllerModalPresentationStyle? modalPresentationStyle;

  /// The page sheet configuration.
  final SheetPresentationControllerConfiguration? pageSheetConfiguration;

  /// Converts the [SafariViewControllerOptions] instance into a [Map] instance for serialization.
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (preferredBarTintColor != null)
        'preferredBarTintColor':
            '#${preferredBarTintColor!.value.toRadixString(16)}',
      if (preferredControlTintColor != null)
        'preferredControlTintColor':
            '#${preferredControlTintColor!.value.toRadixString(16)}',
      if (barCollapsingEnabled != null)
        'barCollapsingEnabled': barCollapsingEnabled,
      if (entersReaderIfAvailable != null)
        'entersReaderIfAvailable': entersReaderIfAvailable,
      if (modalPresentationStyle != null)
        'modalPresentationStyle': modalPresentationStyle!.rawValue,
      if (dismissButtonStyle != null)
        'dismissButtonStyle': dismissButtonStyle!.rawValue,
      if (pageSheetConfiguration != null)
        'pageSheet': pageSheetConfiguration!.toMap(),
    };
  }
}

/// Dismiss button style on the navigation bar of [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller).
///
/// See also:
/// - [SFSafariViewController.DismissButtonStyle](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/dismissbuttonstyle)
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
/// - [UIModalPresentationStyle](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle)
enum ViewControllerModalPresentationStyle {
  /// The default presentation style chosen by the system.
  ///
  /// - Availability: **iOS13.0+**
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
