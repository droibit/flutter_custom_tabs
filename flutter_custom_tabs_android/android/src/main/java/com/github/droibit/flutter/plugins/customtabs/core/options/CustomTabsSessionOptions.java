package com.github.droibit.flutter.plugins.customtabs.core.options;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.droibit.android.customtabs.launcher.CustomTabsPackageProvider;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class CustomTabsSessionOptions {
    private final @NonNull BrowserConfiguration browser;

    public @Nullable Boolean getPrefersDefaultBrowser() {
        return browser.getPrefersDefaultBrowser();
    }

    public @Nullable Set<String> getFallbackCustomTabPackages() {
        return browser.getFallbackCustomTabPackages();
    }

    public CustomTabsSessionOptions(
            @Nullable Boolean prefersExternalBrowser,
            @Nullable Set<String> fallbackCustomTabPackages
    ) {
        browser = new BrowserConfiguration.Builder()
                .setPrefersExternalBrowser(prefersExternalBrowser)
                .setFallbackCustomTabs(fallbackCustomTabPackages)
                .build();
    }

    public @NonNull CustomTabsPackageProvider getAdditionalCustomTabs(@NonNull Context context) {
        return browser.getAdditionalCustomTabs(context);
    }

    public static class Builder {
        private static final String KEY_PREFERS_DEFAULT_BROWSER = "prefersDefaultBrowser";
        private static final String KEY_BROWSER_FALLBACK_CUSTOM_TABS = "fallbackCustomTabs";

        private @Nullable Boolean prefersExternalBrowser;
        private @Nullable Set<String> fallbackCustomTabs;

        @SuppressWarnings("unchecked")
        public @NonNull Builder setOptions(@Nullable Map<String, Object> options) {
            if (options == null) {
                return this;
            }

            if (options.containsKey(KEY_PREFERS_DEFAULT_BROWSER)) {
                prefersExternalBrowser = (Boolean) options.get(KEY_PREFERS_DEFAULT_BROWSER);
            }
            if (options.containsKey(KEY_BROWSER_FALLBACK_CUSTOM_TABS)) {
                fallbackCustomTabs = new HashSet<>((List<String>) options.get(KEY_BROWSER_FALLBACK_CUSTOM_TABS));
            }
            return this;
        }

        public @NonNull Builder setPrefersDefaultBrowser(@Nullable Boolean prefersExternalBrowser) {
            this.prefersExternalBrowser = prefersExternalBrowser;
            return this;
        }

        public @NonNull Builder setFallbackCustomTabs(@Nullable Set<String> fallbackCustomTabs) {
            this.fallbackCustomTabs = fallbackCustomTabs;
            return this;
        }

        public CustomTabsSessionOptions build() {
            return new CustomTabsSessionOptions(
                    prefersExternalBrowser,
                    fallbackCustomTabs
            );
        }
    }
}
