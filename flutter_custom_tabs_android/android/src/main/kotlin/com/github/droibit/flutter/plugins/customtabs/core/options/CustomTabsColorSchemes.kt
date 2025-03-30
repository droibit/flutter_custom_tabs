package com.github.droibit.flutter.plugins.customtabs.core.options

import android.graphics.Color
import androidx.browser.customtabs.CustomTabColorSchemeParams
import androidx.browser.customtabs.CustomTabsIntent.ColorScheme

class CustomTabsColorSchemes(
    @ColorScheme val colorScheme: Int?,
    val lightParams: CustomTabColorSchemeParams?,
    val darkParams: CustomTabColorSchemeParams?,
    val defaultPrams: CustomTabColorSchemeParams?
) {
    class Builder {
        private var colorScheme: Int? = null
        private var lightParams: CustomTabColorSchemeParams? = null
        private var darkParams: CustomTabColorSchemeParams? = null
        private var defaultParams: CustomTabColorSchemeParams? = null

        @Suppress("UNCHECKED_CAST")
        fun setOptions(options: Map<String, Any>?): Builder {
            if (options == null) {
                return this
            }
            colorScheme = (options[KEY_COLOR_SCHEME] as Long?)?.toInt()
            lightParams = buildColorSchemeParams(options[KEY_LIGHT_PARAMS] as Map<String, Any>?)
            darkParams = buildColorSchemeParams(options[KEY_DARK_PARAMS] as Map<String, Any>?)
            defaultParams = buildColorSchemeParams(options[KEY_DEFAULT_PARAMS] as Map<String, Any>?)
            return this
        }

        fun setColorScheme(@ColorScheme colorScheme: Int?): Builder {
            this.colorScheme = colorScheme
            return this
        }

        fun setLightParams(lightParams: CustomTabColorSchemeParams?): Builder {
            this.lightParams = lightParams
            return this
        }

        fun setDarkParams(darkParams: CustomTabColorSchemeParams?): Builder {
            this.darkParams = darkParams
            return this
        }

        fun setDefaultParams(defaultParams: CustomTabColorSchemeParams?): Builder {
            this.defaultParams = defaultParams
            return this
        }

        fun build() = CustomTabsColorSchemes(colorScheme, lightParams, darkParams, defaultParams)

        private fun buildColorSchemeParams(source: Map<String, Any>?): CustomTabColorSchemeParams? {
            if (source == null) {
                return null
            }

            val builder = CustomTabColorSchemeParams.Builder()
            val toolbarColor = source[KEY_TOOLBAR_COLOR] as String?
            if (toolbarColor != null) {
                builder.setToolbarColor(Color.parseColor(toolbarColor))
            }

            val navigationBarColor = source[KEY_NAVIGATION_BAR_COLOR] as String?
            if (navigationBarColor != null) {
                builder.setNavigationBarColor(Color.parseColor(navigationBarColor))
            }

            val navigationBarDividerColor = source[KEY_NAVIGATION_BAR_DIVIDER_COLOR] as String?
            if (navigationBarDividerColor != null) {
                builder.setNavigationBarDividerColor(Color.parseColor(navigationBarDividerColor))
            }
            return builder.build()
        }

        private companion object {
            private const val KEY_COLOR_SCHEME = "colorScheme"
            private const val KEY_LIGHT_PARAMS = "lightParams"
            private const val KEY_DARK_PARAMS = "darkParams"
            private const val KEY_DEFAULT_PARAMS = "defaultParams"
            private const val KEY_TOOLBAR_COLOR = "toolbarColor"
            private const val KEY_NAVIGATION_BAR_COLOR = "navigationBarColor"
            private const val KEY_NAVIGATION_BAR_DIVIDER_COLOR = "navigationBarDividerColor"
        }
    }
}
