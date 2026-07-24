package com.github.droibit.flutter.plugins.customtabs.core.options

import android.content.Context
import com.github.droibit.flutter.plugins.customtabs.core.browser.CustomTabsPackage

class BrowserConfiguration internal constructor(
  val prefersExternalBrowser: Boolean?,
  val prefersDefaultBrowser: Boolean?,
  val fallbackCustomTabPackages: List<String>?,
  val headers: Map<String, String>?,
  val sessionPackageName: String?
) {
  fun getAdditionalCustomTabs(context: Context): List<String> {
    return fallbackCustomTabPackages ?: CustomTabsPackage.getNonChromeCustomTabsPackages(context)
  }

  class Builder {
    private var prefersExternalBrowser: Boolean? = null
    private var prefersDefaultBrowser: Boolean? = null
    private var fallbackCustomTabs: List<String>? = null
    private var headers: Map<String, String>? = null
    private var sessionPackageName: String? = null

    /**
     * @noinspection DataFlowIssue
     */
    @Suppress("UNCHECKED_CAST")
    fun setOptions(options: Map<String, Any>?): Builder {
      if (options == null) {
        return this
      }

      prefersExternalBrowser = options[KEY_PREFERS_EXTERNAL_BROWSER] as Boolean?
      prefersDefaultBrowser = options[KEY_PREFERS_DEFAULT_BROWSER] as Boolean?
      fallbackCustomTabs = options[KEY_FALLBACK_CUSTOM_TABS] as List<String>?
      headers = options[KEY_HEADERS] as Map<String, String>?
      sessionPackageName = options[KEY_SESSION_PACKAGE_NAME] as String?
      return this
    }

    fun setPrefersExternalBrowser(prefersExternalBrowser: Boolean?): Builder {
      this.prefersExternalBrowser = prefersExternalBrowser
      return this
    }

    fun setPrefersDefaultBrowser(prefersDefaultBrowser: Boolean?): Builder {
      this.prefersDefaultBrowser = prefersDefaultBrowser
      return this
    }

    fun setFallbackCustomTabs(fallbackCustomTabs: List<String>?): Builder {
      this.fallbackCustomTabs = fallbackCustomTabs
      return this
    }

    fun setHeaders(headers: Map<String, String>?): Builder {
      this.headers = headers
      return this
    }

    fun setSessionPackageName(sessionPackageName: String?): Builder {
      this.sessionPackageName = sessionPackageName
      return this
    }

    fun build() = BrowserConfiguration(
      prefersExternalBrowser,
      prefersDefaultBrowser,
      fallbackCustomTabs,
      headers,
      sessionPackageName
    )

    private companion object {
      private const val KEY_PREFERS_EXTERNAL_BROWSER = "prefersExternalBrowser"
      private const val KEY_PREFERS_DEFAULT_BROWSER = "prefersDefaultBrowser"
      private const val KEY_FALLBACK_CUSTOM_TABS = "fallbackCustomTabs"
      private const val KEY_HEADERS = "headers"
      private const val KEY_SESSION_PACKAGE_NAME = "sessionPackageName"
    }
  }
}
