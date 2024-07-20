import 'package:meta/meta.dart';

/// The share state that should be applied to the custom tab.
enum CustomTabsShareState {
  /// Applies the default share settings depending on the browser.
  browserDefault(0),

  /// Explicitly does not show a share option in the tab.
  on(1),

  /// Shows a share option in the tab.
  off(2);

  @internal
  const CustomTabsShareState(this.rawValue);

  @internal
  final int rawValue;
}
