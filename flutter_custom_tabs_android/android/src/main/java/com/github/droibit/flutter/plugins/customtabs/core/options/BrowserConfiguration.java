package com.github.droibit.flutter.plugins.customtabs.core.options;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.droibit.android.customtabs.launcher.CustomTabsPackageProvider;
import com.droibit.android.customtabs.launcher.NonChromeCustomTabs;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class BrowserConfiguration {
    private final @Nullable Boolean prefersExternalBrowser;
    private final @Nullable Boolean prefersDefaultBrowser;
    private final @Nullable Set<String> fallbackCustomTabPackages;
    private final @Nullable Map<String, String> headers;
    private final @Nullable String sessionPackageName;

    public boolean getPrefersExternalBrowser() {
        if (prefersExternalBrowser == null) {
            return false;
        }
        return prefersExternalBrowser;
    }

    public @Nullable Boolean getPrefersDefaultBrowser() {
        return prefersDefaultBrowser;
    }

    public @Nullable Set<String> getFallbackCustomTabPackages() {
        return fallbackCustomTabPackages;
    }

    public @Nullable Map<String, String> getHeaders() {
        return headers;
    }

    public @Nullable String getSessionPackageName() {
        return sessionPackageName;
    }

    public BrowserConfiguration() {
        this(false, null, null, null, null);
    }

    public BrowserConfiguration(
            @Nullable Boolean prefersExternalBrowser,
            @Nullable Boolean prefersDefaultBrowser,
            @Nullable Set<String> fallbackCustomTabPackages,
            @Nullable Map<String, String> headers,
            @Nullable String sessionPackageName
    ) {
        this.prefersExternalBrowser = prefersExternalBrowser;
        this.prefersDefaultBrowser = prefersDefaultBrowser;
        this.fallbackCustomTabPackages = fallbackCustomTabPackages;
        this.headers = headers;
        this.sessionPackageName = sessionPackageName;
    }

    public @NonNull CustomTabsPackageProvider getAdditionalCustomTabs(@NonNull Context context) {
        final Set<String> fallbackCustomTabs = this.fallbackCustomTabPackages;
        if (fallbackCustomTabs != null) {
            return new NonChromeCustomTabs(fallbackCustomTabs);
        } else {
            return new NonChromeCustomTabs(context);
        }
    }

    public static class Builder {
        private static final String KEY_PREFERS_EXTERNAL_BROWSER = "prefersExternalBrowser";
        private static final String KEY_PREFERS_DEFAULT_BROWSER = "prefersDefaultBrowser";
        private static final String KEY_BROWSER_FALLBACK_CUSTOM_TABS = "fallbackCustomTabs";
        private static final String KEY_BROWSER_HEADERS = "headers";
        private static final String KEY_SESSION_PACKAGE_NAME = "sessionPackageName";

        private @Nullable Boolean prefersExternalBrowser;
        private @Nullable Boolean prefersDefaultBrowser;
        private @Nullable Set<String> fallbackCustomTabs;
        private @Nullable Map<String, String> headers;
        private @Nullable String sessionPackageName;

        public Builder() {
        }

        /**
         * @noinspection DataFlowIssue
         */
        @SuppressWarnings("unchecked")
        public @NonNull Builder setOptions(@Nullable Map<String, Object> options) {
            if (options == null) {
                return this;
            }

            if (options.containsKey(KEY_PREFERS_EXTERNAL_BROWSER)) {
                prefersExternalBrowser = (Boolean) options.get(KEY_PREFERS_EXTERNAL_BROWSER);
            }
            if (options.containsKey(KEY_PREFERS_DEFAULT_BROWSER)) {
                prefersDefaultBrowser = (Boolean) options.get(KEY_PREFERS_DEFAULT_BROWSER);
            }
            if (options.containsKey(KEY_BROWSER_FALLBACK_CUSTOM_TABS)) {
                fallbackCustomTabs = new HashSet<>((List<String>) options.get(KEY_BROWSER_FALLBACK_CUSTOM_TABS));
            }
            if (options.containsKey(KEY_BROWSER_HEADERS)) {
                headers = (Map<String, String>) options.get(KEY_BROWSER_HEADERS);
            }
            if (options.containsKey(KEY_SESSION_PACKAGE_NAME)) {
                sessionPackageName = (String) options.get(KEY_SESSION_PACKAGE_NAME);
            }
            return this;
        }

        public @NonNull Builder setPrefersExternalBrowser(@Nullable Boolean prefersExternalBrowser) {
            this.prefersExternalBrowser = prefersExternalBrowser;
            return this;
        }

        public @NonNull Builder setPrefersDefaultBrowser(@Nullable Boolean prefersDefaultBrowser) {
            this.prefersDefaultBrowser = prefersDefaultBrowser;
            return this;
        }

        public @NonNull Builder setFallbackCustomTabs(@Nullable Set<String> fallbackCustomTabs) {
            this.fallbackCustomTabs = fallbackCustomTabs;
            return this;
        }

        public @NonNull Builder setHeaders(@Nullable Map<String, String> headers) {
            this.headers = headers;
            return this;
        }

        public @NonNull Builder setSessionPackageName(@Nullable String sessionPackageName) {
            this.sessionPackageName = sessionPackageName;
            return this;
        }

        public @NonNull BrowserConfiguration build() {
            return new BrowserConfiguration(
                    prefersExternalBrowser,
                    prefersDefaultBrowser,
                    fallbackCustomTabs,
                    headers,
                    sessionPackageName
            );
        }
    }
}
