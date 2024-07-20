package com.github.droibit.flutter.plugins.customtabs.core.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent.CloseButtonPosition;

import java.util.Map;

public class CustomTabsCloseButton {
    private final @Nullable String icon;
    private final @Nullable Integer position;

    public @Nullable String getIcon() {
        return icon;
    }

    public @Nullable @CloseButtonPosition Integer getPosition() {
        return position;
    }

    public CustomTabsCloseButton(@Nullable String icon, @Nullable Integer position) {
        this.icon = icon;
        this.position = position;
    }

    public static class Builder {
        private static final String KEY_ICON = "icon";
        private static final String KEY_POSITION = "position";


        private @Nullable String icon;
        private @Nullable Integer position;

        public Builder() {
        }

        public @NonNull Builder setOptions(@NonNull Map<String, Object> options) {
            if (options.containsKey(KEY_ICON)) {
                icon = (String) options.get(KEY_ICON);
            }
            if (options.containsKey(KEY_POSITION)) {
                position = (Integer) options.get(KEY_POSITION);
            }
            return this;
        }

        public @NonNull Builder setIcon(@Nullable String icon) {
            this.icon = icon;
            return this;
        }

        public @NonNull Builder setPosition(@Nullable Integer position) {
            this.position = position;
            return this;
        }

        public @NonNull CustomTabsCloseButton build() {
            return new CustomTabsCloseButton(icon, position);
        }
    }
}
