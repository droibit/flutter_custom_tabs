package com.github.droibit.flutter.plugins.customtabs.core.options

import android.content.Context
import com.droibit.android.customtabs.launcher.CustomTabsPackageProvider

class CustomTabsSessionOptions private constructor(
    private val browser: BrowserConfiguration
) {
    constructor(
        prefersExternalBrowser: Boolean?,
        fallbackCustomTabPackages: Set<String>?
    ) : this(
        BrowserConfiguration.Builder()
            .setPrefersExternalBrowser(prefersExternalBrowser)
            .setFallbackCustomTabs(fallbackCustomTabPackages)
            .build()
    )

    val prefersDefaultBrowser: Boolean?
        get() = browser.prefersDefaultBrowser

    val fallbackCustomTabPackages: Set<String>?
        get() = browser.fallbackCustomTabPackages

    fun getAdditionalCustomTabs(context: Context): CustomTabsPackageProvider {
        return browser.getAdditionalCustomTabs(context)
    }

    class Builder {
        private var prefersExternalBrowser: Boolean? = null
        private var fallbackCustomTabs: Set<String>? = null

        fun setOptions(options: Map<String, Any?>?): Builder {
            if (options == null) {
                return this
            }

            prefersExternalBrowser = options[KEY_PREFERS_DEFAULT_BROWSER] as Boolean?
            @Suppress("UNCHECKED_CAST")
            fallbackCustomTabs = (options[KEY_FALLBACK_CUSTOM_TABS] as List<String>?)?.toSet()
            return this
        }

        fun setPrefersDefaultBrowser(prefersExternalBrowser: Boolean?): Builder {
            this.prefersExternalBrowser = prefersExternalBrowser
            return this
        }

        fun setFallbackCustomTabs(fallbackCustomTabs: Set<String>?): Builder {
            this.fallbackCustomTabs = fallbackCustomTabs
            return this
        }

        fun build() = CustomTabsSessionOptions(
            prefersExternalBrowser,
            fallbackCustomTabs
        )

        private companion object {
            private const val KEY_PREFERS_DEFAULT_BROWSER = "prefersDefaultBrowser"
            private const val KEY_FALLBACK_CUSTOM_TABS = "fallbackCustomTabs"
        }
    }
}
