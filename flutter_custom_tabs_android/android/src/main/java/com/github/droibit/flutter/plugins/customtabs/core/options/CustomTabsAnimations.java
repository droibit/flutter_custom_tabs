package com.github.droibit.flutter.plugins.customtabs.core.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

public class CustomTabsAnimations {
    private final @Nullable String startEnter;
    private final @Nullable String startExit;
    private final @Nullable String endEnter;
    private final @Nullable String endExit;

    public @Nullable String getStartEnter() {
        return startEnter;
    }

    public @Nullable String getStartExit() {
        return startExit;
    }

    public @Nullable String getEndEnter() {
        return endEnter;
    }

    public @Nullable String getEndExit() {
        return endExit;
    }

    public CustomTabsAnimations(
            @Nullable String startEnter,
            @Nullable String startExit,
            @Nullable String endEnter,
            @Nullable String endExit
    ) {
        this.startEnter = startEnter;
        this.startExit = startExit;
        this.endEnter = endEnter;
        this.endExit = endExit;
    }

    public static class Builder {
        private static final String KEY_START_ENTER = "startEnter";
        private static final String KEY_START_EXIT = "startExit";
        private static final String KEY_END_ENTER = "endEnter";
        private static final String KEY_END_EXIT = "endExit";

        private @Nullable String startEnter;
        private @Nullable String startExit;
        private @Nullable String endEnter;
        private @Nullable String endExit;

        public Builder() {
        }

        public @NonNull Builder setOptions(@Nullable Map<String, Object> options) {
            if (options == null) {
                return this;
            }

            if (options.containsKey(KEY_START_ENTER)) {
                startEnter = (String) options.get(KEY_START_ENTER);
            }
            if (options.containsKey(KEY_START_EXIT)) {
                startExit = (String) options.get(KEY_START_EXIT);
            }
            if (options.containsKey(KEY_END_ENTER)) {
                endEnter = (String) options.get(KEY_END_ENTER);
            }
            if (options.containsKey(KEY_END_EXIT)) {
                endExit = (String) options.get(KEY_END_EXIT);
            }
            return this;
        }

        public @NonNull Builder setStartEnter(@Nullable String startEnter) {
            this.startEnter = startEnter;
            return this;
        }

        public @NonNull Builder setStartExit(@Nullable String startExit) {
            this.startExit = startExit;
            return this;
        }

        public @NonNull Builder setEndEnter(@Nullable String endEnter) {
            this.endEnter = endEnter;
            return this;
        }

        public @NonNull Builder setEndExit(@Nullable String endExit) {
            this.endExit = endExit;
            return this;
        }

        public @NonNull CustomTabsAnimations build() {
            return new CustomTabsAnimations(startEnter, startExit, endEnter, endExit);
        }
    }
}
