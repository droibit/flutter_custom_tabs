package com.github.droibit.flutter.plugins.customtabs.core.options;

import android.graphics.Color;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabColorSchemeParams;
import androidx.browser.customtabs.CustomTabsIntent.ColorScheme;

import java.util.Map;

public class CustomTabsColorSchemes {
    private final @Nullable Integer colorScheme;
    private final @Nullable CustomTabColorSchemeParams lightParams;
    private final @Nullable CustomTabColorSchemeParams darkParams;
    private final @Nullable CustomTabColorSchemeParams defaultPrams;

    public @Nullable @ColorScheme Integer getColorScheme() {
        return colorScheme;
    }

    public @Nullable CustomTabColorSchemeParams getLightParams() {
        return lightParams;
    }

    public @Nullable CustomTabColorSchemeParams getDefaultPrams() {
        return defaultPrams;
    }

    public @Nullable CustomTabColorSchemeParams getDarkParams() {
        return darkParams;
    }

    public CustomTabsColorSchemes(
            @Nullable @ColorScheme Integer colorScheme,
            @Nullable CustomTabColorSchemeParams lightParams,
            @Nullable CustomTabColorSchemeParams darkParams,
            @Nullable CustomTabColorSchemeParams defaultPrams
    ) {
        this.colorScheme = colorScheme;
        this.lightParams = lightParams;
        this.darkParams = darkParams;
        this.defaultPrams = defaultPrams;
    }

    public static class Builder {
        private static final String KEY_COLOR_SCHEME = "colorScheme";
        private static final String KEY_LIGHT_PARAMS = "lightParams";
        private static final String KEY_DARK_PARAMS = "darkParams";
        private static final String KEY_DEFAULT_PARAMS = "defaultParams";
        private static final String KEY_TOOLBAR_COLOR = "toolbarColor";
        private static final String KEY_NAVIGATION_BAR_COLOR = "navigationBarColor";
        private static final String KEY_NAVIGATION_BAR_DIVIDER_COLOR = "navigationBarDividerColor";

        private @Nullable Integer colorScheme;
        private @Nullable CustomTabColorSchemeParams lightParams;
        private @Nullable CustomTabColorSchemeParams darkParams;
        private @Nullable CustomTabColorSchemeParams defaultParams;

        public Builder() {
        }

        @SuppressWarnings("unchecked")
        public @NonNull Builder setOptions(@NonNull Map<String, Object> options) {
            if (options.containsKey(KEY_COLOR_SCHEME)) {
                colorScheme = (Integer) options.get(KEY_COLOR_SCHEME);
            }

            if (options.containsKey(KEY_LIGHT_PARAMS)) {
                lightParams = buildColorSchemeParams((Map<String, Object>) options.get(KEY_LIGHT_PARAMS));
            }

            if (options.containsKey(KEY_DARK_PARAMS)) {
                darkParams = buildColorSchemeParams((Map<String, Object>) options.get(KEY_DARK_PARAMS));
            }

            if (options.containsKey(KEY_DEFAULT_PARAMS)) {
                defaultParams = buildColorSchemeParams((Map<String, Object>) options.get(KEY_DEFAULT_PARAMS));
            }
            return this;
        }

        public @NonNull Builder setColorScheme(@Nullable @ColorScheme Integer colorScheme) {
            this.colorScheme = colorScheme;
            return this;
        }

        public @NonNull Builder setLightParams(@Nullable CustomTabColorSchemeParams lightParams) {
            this.lightParams = lightParams;
            return this;
        }

        public @NonNull Builder setDarkParams(@Nullable CustomTabColorSchemeParams darkParams) {
            this.darkParams = darkParams;
            return this;
        }

        public @NonNull Builder setDefaultParams(@Nullable CustomTabColorSchemeParams defaultParams) {
            this.defaultParams = defaultParams;
            return this;
        }

        public @NonNull CustomTabsColorSchemes build() {
            return new CustomTabsColorSchemes(colorScheme, lightParams, darkParams, defaultParams);
        }

        private static @Nullable CustomTabColorSchemeParams buildColorSchemeParams(@Nullable Map<String, Object> source) {
            if (source == null) {
                return null;
            }
            final CustomTabColorSchemeParams.Builder builder = new CustomTabColorSchemeParams.Builder();
            final @Nullable String toolbarColor = (String) source.get(KEY_TOOLBAR_COLOR);
            if (toolbarColor != null) {
                builder.setToolbarColor(Color.parseColor(toolbarColor));
            }

            final @Nullable String navigationBarColor = (String) source.get(KEY_NAVIGATION_BAR_COLOR);
            if (navigationBarColor != null) {
                builder.setNavigationBarColor(Color.parseColor(navigationBarColor));
            }

            final @Nullable String navigationBarDividerColor = (String) source.get(KEY_NAVIGATION_BAR_DIVIDER_COLOR);
            if (navigationBarDividerColor != null) {
                builder.setNavigationBarDividerColor(Color.parseColor(navigationBarDividerColor));
            }
            return builder.build();
        }
    }
}
