package com.github.droibit.flutter.plugins.customtabs.core.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent.ShareState;

import java.util.Map;

public class CustomTabsIntentOptions {
    private final @Nullable CustomTabsColorSchemes colorSchemes;
    private final @Nullable Boolean urlBarHidingEnabled;
    private final @Nullable Integer shareState;
    private final @Nullable Boolean showTitle;
    private final @Nullable Boolean instantAppsEnabled;
    private final @Nullable CustomTabsCloseButton closeButton;
    private final @Nullable CustomTabsAnimations animations;
    private final @Nullable BrowserConfiguration browser;
    private final @Nullable PartialCustomTabsConfiguration partial;

    public @Nullable CustomTabsColorSchemes getColorSchemes() {
        return colorSchemes;
    }

    public @Nullable Boolean getUrlBarHidingEnabled() {
        return urlBarHidingEnabled;
    }

    public @Nullable @ShareState Integer getShareState() {
        return shareState;
    }

    public @Nullable Boolean getShowTitle() {
        return showTitle;
    }

    public @Nullable Boolean getInstantAppsEnabled() {
        return instantAppsEnabled;
    }

    public @Nullable CustomTabsCloseButton getCloseButton() {
        return closeButton;
    }

    public @Nullable CustomTabsAnimations getAnimations() {
        return animations;
    }

    public @Nullable BrowserConfiguration getBrowser() {
        return browser;
    }

    public @Nullable PartialCustomTabsConfiguration getPartial() {
        return partial;
    }

    public CustomTabsIntentOptions(
            @Nullable CustomTabsColorSchemes colorSchemes,
            @Nullable Boolean urlBarHidingEnabled,
            @Nullable Integer shareState,
            @Nullable Boolean showTitle,
            @Nullable Boolean instantAppsEnabled,
            @Nullable CustomTabsCloseButton closeButton,
            @Nullable CustomTabsAnimations animations,
            @Nullable BrowserConfiguration browser,
            @Nullable PartialCustomTabsConfiguration partial
    ) {
        this.colorSchemes = colorSchemes;
        this.urlBarHidingEnabled = urlBarHidingEnabled;
        this.shareState = shareState;
        this.showTitle = showTitle;
        this.instantAppsEnabled = instantAppsEnabled;
        this.closeButton = closeButton;
        this.animations = animations;
        this.browser = browser;
        this.partial = partial;
    }

    public static class Builder {
        private static final String KEY_COLOR_SCHEMES = "colorSchemes";
        private static final String KEY_URL_BAR_HIDING_ENABLED = "urlBarHidingEnabled";
        private static final String KEY_SHARE_STATE = "shareState";
        private static final String KEY_SHOW_TITLE = "showTitle";
        private static final String KEY_INSTANT_APPS_ENABLED = "instantAppsEnabled";
        private static final String KEY_CLOSE_BUTTON = "closeButton";
        private static final String KEY_ANIMATIONS = "animations";
        private static final String KEY_BROWSER = "browser";
        private static final String KEY_PARTIAL = "partial";

        private @Nullable CustomTabsColorSchemes colorSchemes;
        private @Nullable Boolean urlBarHidingEnabled;
        private @Nullable Integer shareState;
        private @Nullable Boolean showTitle;
        private @Nullable Boolean instantAppsEnabled;
        private @Nullable CustomTabsCloseButton closeButton;
        private @Nullable CustomTabsAnimations animations;
        private @Nullable BrowserConfiguration browser;
        private @Nullable PartialCustomTabsConfiguration partial;

        public Builder() {
        }

        /**
         * @noinspection unchecked, DataFlowIssue
         */
        public @NonNull Builder setOptions(@NonNull Map<String, Object> options) {
            if (options.containsKey(KEY_COLOR_SCHEMES)) {
                colorSchemes = new CustomTabsColorSchemes.Builder()
                        .setOptions((Map<String, Object>) options.get(KEY_COLOR_SCHEMES))
                        .build();
            }
            if (options.containsKey(KEY_URL_BAR_HIDING_ENABLED)) {
                urlBarHidingEnabled = (Boolean) options.get(KEY_URL_BAR_HIDING_ENABLED);
            }
            if (options.containsKey(KEY_SHARE_STATE)) {
                shareState = (Integer) options.get(KEY_SHARE_STATE);
            }
            if (options.containsKey(KEY_SHOW_TITLE)) {
                showTitle = (Boolean) options.get(KEY_SHOW_TITLE);
            }
            if (options.containsKey(KEY_INSTANT_APPS_ENABLED)) {
                instantAppsEnabled = (Boolean) options.get(KEY_INSTANT_APPS_ENABLED);
            }
            if (options.containsKey(KEY_CLOSE_BUTTON)) {
                closeButton = new CustomTabsCloseButton.Builder()
                        .setOptions((Map<String, Object>) options.get(KEY_CLOSE_BUTTON))
                        .build();
            }

            if (options.containsKey(KEY_ANIMATIONS)) {
                animations = new CustomTabsAnimations.Builder()
                        .setOptions((Map<String, Object>) options.get(KEY_ANIMATIONS))
                        .build();
            }
            if (options.containsKey(KEY_BROWSER)) {
                browser = new BrowserConfiguration.Builder()
                        .setOptions((Map<String, Object>) options.get(KEY_BROWSER))
                        .build();
            }
            if (options.containsKey(KEY_PARTIAL)) {
                partial = new PartialCustomTabsConfiguration.Builder()
                        .setOptions((Map<String, Object>) options.get(KEY_PARTIAL))
                        .build();
            }
            return this;
        }

        public @NonNull Builder setColorSchemes(@Nullable CustomTabsColorSchemes colorSchemes) {
            this.colorSchemes = colorSchemes;
            return this;
        }

        public @NonNull Builder setUrlBarHidingEnabled(@Nullable Boolean urlBarHidingEnabled) {
            this.urlBarHidingEnabled = urlBarHidingEnabled;
            return this;
        }

        public @NonNull Builder setShareState(@Nullable @ShareState Integer shareState) {
            this.shareState = shareState;
            return this;
        }

        public @NonNull Builder setShowTitle(@Nullable Boolean showTitle) {
            this.showTitle = showTitle;
            return this;
        }

        public @NonNull Builder setInstantAppsEnabled(@Nullable Boolean instantAppsEnabled) {
            this.instantAppsEnabled = instantAppsEnabled;
            return this;
        }

        public @NonNull Builder setCloseButton(@Nullable CustomTabsCloseButton closeButton) {
            this.closeButton = closeButton;
            return this;
        }

        public @NonNull Builder setAnimations(@Nullable CustomTabsAnimations animations) {
            this.animations = animations;
            return this;
        }

        public @NonNull Builder setBrowser(@Nullable BrowserConfiguration browser) {
            this.browser = browser;
            return this;
        }

        public @NonNull Builder setPartial(@Nullable PartialCustomTabsConfiguration partial) {
            this.partial = partial;
            return this;
        }

        public @NonNull CustomTabsIntentOptions build() {
            return new CustomTabsIntentOptions(
                    colorSchemes,
                    urlBarHidingEnabled,
                    shareState,
                    showTitle,
                    instantAppsEnabled,
                    closeButton,
                    animations,
                    browser,
                    partial
            );
        }
    }
}
