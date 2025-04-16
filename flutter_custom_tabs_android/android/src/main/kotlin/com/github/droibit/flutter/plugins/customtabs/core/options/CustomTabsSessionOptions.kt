package com.github.droibit.flutter.plugins.customtabs.core.options

import android.content.Context
import androidx.annotation.VisibleForTesting
import com.droibit.android.customtabs.launcher.CustomTabsPackageProvider

class CustomTabsSessionOptions @VisibleForTesting internal constructor(
  private val browser: BrowserConfiguration
) {
  constructor(
    prefersDefaultBrowser: Boolean?,
    fallbackCustomTabPackages: Set<String>?
  ) : this(
    BrowserConfiguration.Builder()
      .setPrefersDefaultBrowser(prefersDefaultBrowser)
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
    private var prefersDefaultBrowser: Boolean? = null
    private var fallbackCustomTabs: Set<String>? = null

    fun setOptions(options: Map<String, Any>?): Builder {
      if (options == null) {
        return this
      }

      prefersDefaultBrowser = options[KEY_PREFERS_DEFAULT_BROWSER] as Boolean?
      @Suppress("UNCHECKED_CAST")
      fallbackCustomTabs = (options[KEY_FALLBACK_CUSTOM_TABS] as List<String>?)?.toSet()
      return this
    }

    fun setPrefersDefaultBrowser(prefersExternalBrowser: Boolean?): Builder {
      this.prefersDefaultBrowser = prefersExternalBrowser
      return this
    }

    fun setFallbackCustomTabs(fallbackCustomTabs: Set<String>?): Builder {
      this.fallbackCustomTabs = fallbackCustomTabs
      return this
    }

    fun build() = CustomTabsSessionOptions(
      prefersDefaultBrowser,
      fallbackCustomTabs
    )

    private companion object {
      private const val KEY_PREFERS_DEFAULT_BROWSER = "prefersDefaultBrowser"
      private const val KEY_FALLBACK_CUSTOM_TABS = "fallbackCustomTabs"
    }
  }
}
