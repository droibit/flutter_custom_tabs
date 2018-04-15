package com.github.droibit.flutter.plugins.customtabs.internal;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.RestrictTo;
import android.support.customtabs.CustomTabsIntent;
import com.droibit.android.customtabs.launcher.CustomTabsFallback;
import com.droibit.android.customtabs.launcher.CustomTabsLauncher;
import java.util.Map;

@RestrictTo(RestrictTo.Scope.LIBRARY) public class Launcher {

  private static final String KEY_OPTIONS_TOOLBAR_COLOR = "toolbarColor";
  private static final String KEY_OPTIONS_ENABLE_URL_BAR_HIDING = "enableUrlBarHiding";
  private static final String KEY_OPTIONS_SHOW_PAGE_TITLE = "showPageTitle";
  private static final String KEY_OPTIONS_DEFAULT_SHARE_MENU_ITEM = "enableDefaultShare";

  @NonNull public CustomTabsIntent buildIntent(@NonNull Map<String, Object> options) {
    final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
    if (options.containsKey(KEY_OPTIONS_TOOLBAR_COLOR)) {
      final String colorString = (String) options.get(KEY_OPTIONS_TOOLBAR_COLOR);
      builder.setToolbarColor(Color.parseColor(colorString));
    }

    if (options.containsKey(KEY_OPTIONS_ENABLE_URL_BAR_HIDING) && ((Boolean) options.get(
        KEY_OPTIONS_ENABLE_URL_BAR_HIDING))) {
      builder.enableUrlBarHiding();
    }

    if (options.containsKey(KEY_OPTIONS_DEFAULT_SHARE_MENU_ITEM) && ((Boolean) options.get(
        KEY_OPTIONS_DEFAULT_SHARE_MENU_ITEM))) {
      builder.addDefaultShareMenuItem();
    }

    if (options.containsKey(KEY_OPTIONS_SHOW_PAGE_TITLE)) {
      builder.setShowTitle(((Boolean) options.get(KEY_OPTIONS_SHOW_PAGE_TITLE)));
    }
    return builder.build();
  }

  public void launch(@NonNull Context context, @NonNull Uri uri,
      @NonNull CustomTabsIntent customTabsIntent) {
    final CustomTabsFallback fallback = createFallback(customTabsIntent);
    CustomTabsLauncher.launch(context, customTabsIntent, uri, fallback);
  }

  @NonNull
  private CustomTabsFallback createFallback(final @NonNull CustomTabsIntent customTabsIntent) {
    return new CustomTabsFallback() {
      @Override public void openUrl(@NonNull Context context, @NonNull Uri url) {
        final Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(url);
        intent.setFlags(customTabsIntent.intent.getFlags());
        context.startActivity(intent);
      }
    };
  }
}
