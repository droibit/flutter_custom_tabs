package com.github.droibit.flutter.plugins.customtabs.core.options;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent.ActivityHeightResizeBehavior;

import java.util.Map;

public class PartialCustomTabsConfiguration {
    private final @Nullable Double initialHeight;
    private final @Nullable Integer activityHeightResizeBehavior;
    private final @Nullable Integer cornerRadius;

    public @Nullable Double getInitialHeight() {
        return initialHeight;
    }

    public @Nullable @ActivityHeightResizeBehavior Integer getActivityHeightResizeBehavior() {
        return activityHeightResizeBehavior;
    }

    public @Nullable Integer getCornerRadius() {
        return cornerRadius;
    }

    public PartialCustomTabsConfiguration(
            @Nullable Double initialHeight,
            @Nullable Integer activityHeightResizeBehavior,
            @Nullable Integer cornerRadius
    ) {
        this.initialHeight = initialHeight;
        this.activityHeightResizeBehavior = activityHeightResizeBehavior;
        this.cornerRadius = cornerRadius;
    }

    public static class Builder {
        private static final String KEY_INITIAL_HEIGHT = "initialHeight";
        private static final String KEY_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR = "activityHeightResizeBehavior";
        private static final String KEY_CORNER_RADIUS = "cornerRadius";

        private @Nullable Double initialHeight;
        private @Nullable Integer activityHeightResizeBehavior;
        private @Nullable Integer cornerRadius;

        public @NonNull Builder setOptions(@Nullable Map<String, Object> options) {
            if (options == null) {
                return this;
            }

            if (options.containsKey(KEY_INITIAL_HEIGHT)) {
                initialHeight = (Double) options.get(KEY_INITIAL_HEIGHT);
            }
            if (options.containsKey(KEY_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR)) {
                activityHeightResizeBehavior = (Integer) options.get(KEY_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR);
            }
            if (options.containsKey(KEY_CORNER_RADIUS)) {
                cornerRadius = (Integer) options.get(KEY_CORNER_RADIUS);
            }
            return this;
        }

        public @NonNull Builder setInitialHeight(double initialHeight) {
            this.initialHeight = initialHeight;
            return this;
        }

        public @NonNull Builder setActivityHeightResizeBehavior(int activityHeightResizeBehavior) {
            this.activityHeightResizeBehavior = activityHeightResizeBehavior;
            return this;
        }

        public @NonNull Builder setCornerRadius(@Nullable Integer cornerRadius) {
            this.cornerRadius = cornerRadius;
            return this;
        }

        public @NonNull PartialCustomTabsConfiguration build() {
            return new PartialCustomTabsConfiguration(
                    initialHeight,
                    activityHeightResizeBehavior,
                    cornerRadius
            );
        }
    }
}
