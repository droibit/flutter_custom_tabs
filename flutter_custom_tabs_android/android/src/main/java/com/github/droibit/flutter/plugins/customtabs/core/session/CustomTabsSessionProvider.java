package com.github.droibit.flutter.plugins.customtabs.core.session;

import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsSession;

public interface CustomTabsSessionProvider {
    @Nullable
    CustomTabsSession getSession(@Nullable String packageName);
}
