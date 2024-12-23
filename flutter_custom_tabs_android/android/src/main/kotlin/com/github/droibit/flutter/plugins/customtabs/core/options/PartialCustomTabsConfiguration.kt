package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.annotation.Dimension
import androidx.annotation.Dimension.DP
import androidx.browser.customtabs.CustomTabsIntent.ActivityHeightResizeBehavior

class PartialCustomTabsConfiguration(
    val initialHeight: Double?,
    @ActivityHeightResizeBehavior val activityHeightResizeBehavior: Int?,
    val cornerRadius: Int?
) {
    class Builder {
        private var initialHeight: Double? = null
        private var activityHeightResizeBehavior: Int? = null
        private var cornerRadius: Int? = null

        fun setOptions(options: Map<String, Any?>?): Builder {
            if (options == null) {
                return this
            }

            initialHeight = options[KEY_INITIAL_HEIGHT] as Double?
            activityHeightResizeBehavior = options[KEY_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR] as Int?
            cornerRadius = options[KEY_CORNER_RADIUS] as Int?
            return this
        }

        fun setInitialHeight(initialHeight: Double?): Builder {
            this.initialHeight = initialHeight
            return this
        }

        fun setActivityHeightResizeBehavior(
            @ActivityHeightResizeBehavior activityHeightResizeBehavior: Int?
        ): Builder {
            this.activityHeightResizeBehavior = activityHeightResizeBehavior
            return this
        }

        fun setCornerRadius(@Dimension(unit = DP) cornerRadius: Int?): Builder {
            this.cornerRadius = cornerRadius
            return this
        }

        fun build(): PartialCustomTabsConfiguration {
            return PartialCustomTabsConfiguration(
                initialHeight,
                activityHeightResizeBehavior,
                cornerRadius
            )
        }

        private companion object {
            private const val KEY_INITIAL_HEIGHT = "initialHeight"
            private const val KEY_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR = "activityHeightResizeBehavior"
            private const val KEY_CORNER_RADIUS = "cornerRadius"
        }
    }
}
