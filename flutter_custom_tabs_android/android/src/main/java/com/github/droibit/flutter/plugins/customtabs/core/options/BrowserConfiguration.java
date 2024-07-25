package com.github.droibit.flutter.plugins.customtabs.core.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;
import java.util.Map;

public class BrowserConfiguration {
    private final @Nullable Boolean prefersExternalBrowser;
    private final @Nullable Boolean prefersDefaultBrowser;
    private final @Nullable List<String> fallbackCustomTabs;
    private final @Nullable Map<String, String> headers;

    public boolean getPrefersExternalBrowser() {
        if (prefersExternalBrowser == null) {
            return false;
        }
        return prefersExternalBrowser;
    }

    public @Nullable Boolean getPrefersDefaultBrowser() {
        return prefersDefaultBrowser;
    }

    public @Nullable List<String> getFallbackCustomTabs() {
        return fallbackCustomTabs;
    }

    public @Nullable Map<String, String> getHeaders() {
        return headers;
    }

    public BrowserConfiguration() {
        this(false, null, null, null);
    }

    public BrowserConfiguration(
            @Nullable Boolean prefersExternalBrowser,
            @Nullable Boolean prefersDefaultBrowser,
            @Nullable List<String> fallbackCustomTabs,
            @Nullable Map<String, String> headers
    ) {
        this.prefersExternalBrowser = prefersExternalBrowser;
        this.prefersDefaultBrowser = prefersDefaultBrowser;
        this.fallbackCustomTabs = fallbackCustomTabs;
        this.headers = headers;
    }

    public static class Builder {
        private static final String KEY_PREFERS_EXTERNAL_BROWSER = "prefersExternalBrowser";
        private static final String KEY_PREFERS_DEFAULT_BROWSER = "prefersDefaultBrowser";
        private static final String KEY_BROWSER_FALLBACK_CUSTOM_TABS = "fallbackCustomTabs";
        private static final String KEY_BROWSER_HEADERS = "headers";

        private @Nullable Boolean prefersExternalBrowser;
        private @Nullable Boolean prefersDefaultBrowser;
        private @Nullable List<String> fallbackCustomTabs;
        private @Nullable Map<String, String> headers;

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
                fallbackCustomTabs = (List<String>) options.get(KEY_BROWSER_FALLBACK_CUSTOM_TABS);
            }
            if (options.containsKey(KEY_BROWSER_HEADERS)) {
                headers = (Map<String, String>) options.get(KEY_BROWSER_HEADERS);
            }
            return this;
        }

        public @NonNull Builder setPrefersExternalBrowser(boolean prefersExternalBrowser) {
            this.prefersExternalBrowser = prefersExternalBrowser;
            return this;
        }

        public @NonNull Builder setPrefersDefaultBrowser(@Nullable Boolean prefersDefaultBrowser) {
            this.prefersDefaultBrowser = prefersDefaultBrowser;
            return this;
        }

        public @NonNull Builder setFallbackCustomTabs(@Nullable List<String> fallbackCustomTabs) {
            this.fallbackCustomTabs = fallbackCustomTabs;
            return this;
        }

        public @NonNull Builder setHeaders(@Nullable Map<String, String> headers) {
            this.headers = headers;
            return this;
        }

        public @NonNull BrowserConfiguration build() {
            return new BrowserConfiguration(
                    prefersExternalBrowser,
                    prefersDefaultBrowser,
                    fallbackCustomTabs,
                    headers
            );
        }
    }
}
