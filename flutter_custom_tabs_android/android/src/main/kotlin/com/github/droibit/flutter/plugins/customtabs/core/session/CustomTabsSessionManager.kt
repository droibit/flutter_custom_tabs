package com.github.droibit.flutter.plugins.customtabs.core.session

import android.content.Context
import androidx.annotation.VisibleForTesting
import androidx.browser.customtabs.CustomTabsSession
import com.droibit.android.customtabs.launcher.getCustomTabsPackage
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsSessionOptions

class CustomTabsSessionManager @VisibleForTesting internal constructor(
  private val cachedSessions: MutableMap<String, CustomTabsSessionController>
) : CustomTabsSessionProvider {
  constructor() : this(mutableMapOf())

  fun createSessionOptions(options: Map<String, Any>?): CustomTabsSessionOptions {
    return CustomTabsSessionOptions.Builder()
      .setOptions(options)
      .build()
  }

  fun createSessionController(
    context: Context,
    options: CustomTabsSessionOptions
  ): CustomTabsSessionController? {
    val prefersDefaultBrowser = options.prefersDefaultBrowser
    val customTabsPackage = getCustomTabsPackage(
      context,
      ignoreDefault = prefersDefaultBrowser != true,
      additionalCustomTabs = options.getAdditionalCustomTabs(context)
    ) ?: return null

    return cachedSessions[customTabsPackage]
      ?: CustomTabsSessionController(customTabsPackage).also {
        cachedSessions[customTabsPackage] = it
      }
  }

  fun getSessionController(packageName: String): CustomTabsSessionController? {
    return cachedSessions[packageName]
  }

  override fun getSession(packageName: String?): CustomTabsSession? {
    return packageName?.let { cachedSessions[it]?.session }
  }

  fun invalidateSession(packageName: String) {
    val controller = cachedSessions[packageName] ?: return
    controller.unbindCustomTabsService()
    cachedSessions.remove(packageName)
  }

  fun handleActivityChange(activity: Context?) {
    for (controller in cachedSessions.values) {
      if (activity == null) {
        controller.unbindCustomTabsService()
      } else {
        controller.bindCustomTabsService(activity)
      }
    }
  }
}
