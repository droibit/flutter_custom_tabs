import 'package:meta/meta.dart';

/// The configuration for close button on the custom tab.
@immutable
class CustomTabsCloseButton {
  const CustomTabsCloseButton({
    this.icon,
    this.position,
  });

  /// Resource identifier of the close button icon for the custom tab.
  final String? icon;

  /// The position of the close button on the custom tab.
  final CustomTabsCloseButtonPosition? position;
}

/// The position of the close button on the custom tab.
enum CustomTabsCloseButtonPosition {
  /// Positions the close button at the start of the toolbar.
  start(1),

  /// Positions the close button at the end of the toolbar.
  end(2);

  @internal
  const CustomTabsCloseButtonPosition(this.rawValue);

  @internal
  final int rawValue;
}

/// Build-in close button icon for custom tabs.
class CustomTabsCloseButtonIcon {
  /// The resource ID of build-in back arrow button icon.
  static String get back => "fct_ic_arrow_back";
}
