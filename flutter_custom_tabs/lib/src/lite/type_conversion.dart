import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';

import 'launch_options.dart';

extension LaunchOptionsConverter on LaunchOptions {
  /// Converts to [CustomTabsOptions].
  CustomTabsOptions toCustomTabsOptions() {
    CustomTabsColorSchemes? colorSchemes;
    if (barColor != null || systemNavigationBarParams != null) {
      colorSchemes = CustomTabsColorSchemes.defaults(
        toolbarColor: barColor,
        navigationBarColor: systemNavigationBarParams?.backgroundColor,
        navigationBarDividerColor: systemNavigationBarParams?.dividerColor,
      );
    }

    bool? urlBarHidingEnabled;
    if (barFixingEnabled != null) {
      urlBarHidingEnabled = !(barFixingEnabled!);
    }
    return CustomTabsOptions(
      colorSchemes: colorSchemes,
      urlBarHidingEnabled: urlBarHidingEnabled,
      shareState: CustomTabsShareState.on,
      showTitle: true,
      browser: const CustomTabsBrowserConfiguration(
        prefersDefaultBrowser: true,
      ),
    );
  }

  /// Converts to [SafariViewControllerOptions].
  SafariViewControllerOptions toSafariViewControllerOptions() {
    bool? barCollapsingEnabled;
    if (barFixingEnabled != null) {
      barCollapsingEnabled = !(barFixingEnabled!);
    }
    return SafariViewControllerOptions(
      preferredBarTintColor: barColor,
      preferredControlTintColor: onBarColor,
      barCollapsingEnabled: barCollapsingEnabled,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.done,
    );
  }
}
