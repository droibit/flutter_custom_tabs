@file:JvmName("CustomTabsIntentHelper")

package com.github.droibit.flutter.plugins.customtabs.core.browser

import android.content.Context
import androidx.browser.customtabs.CustomTabsClient
import androidx.browser.customtabs.CustomTabsIntent
import com.github.droibit.flutter.plugins.customtabs.core.browser.CustomTabsPackage.CHROME_PACKAGES

/**
 * Sets the package name of Chrome or an alternative browser that supports Custom Tabs
 * to the [CustomTabsIntent] explicitly for launching URLs as Custom Tabs.
 *
 * ## Browser Priorities
 * 1. [Chrome](https://play.google.com/store/apps/details?id=com.android.chrome).
 * 2. [Chrome Beta](https://play.google.com/store/apps/details?id=com.chrome.beta).
 * 3. [Chrome Dev](https://play.google.com/store/apps/details?id=com.chrome.dev).
 * 4. Local(com.google.android.apps.chrome).
 * 5. (Optional) Additional browser packages that support Custom Tabs.
 *
 * @param context The source Context
 * @param additionalCustomTabs Additional browser packages that support Custom Tabs.
 *
 * @return The modified [CustomTabsIntent] with the specified package set.
 */
fun CustomTabsIntent.setChromeCustomTabsPackage(
  context: Context,
  additionalCustomTabs: List<String>? = null,
): CustomTabsIntent {
  setCustomTabsPackage(context, true, additionalCustomTabs)
  return this
}

/**
 * Explicitly sets the package name of the browser that supports Custom Tabs
 * to the [CustomTabsIntent] to launch it as a Custom Tab.
 *
 * ## Browser Priorities
 * 1. The default browser that supports Custom Tabs.
 * 2. [Chrome](https://play.google.com/store/apps/details?id=com.android.chrome).
 * 3. [Chrome Beta](https://play.google.com/store/apps/details?id=com.chrome.beta).
 * 4. [Chrome Dev](https://play.google.com/store/apps/details?id=com.chrome.dev).
 * 5. Local(com.google.android.apps.chrome).
 * 6. (Optional) Additional browser packages that support Custom Tabs.
 *
 * @param context The source Context
 * @param additionalCustomTabs Additional browser packages to be used if the default browser or Chrome are not available.
 *
 * @return The modified [CustomTabsIntent] with the specified package set.
 */
fun CustomTabsIntent.setCustomTabsPackage(
  context: Context,
  additionalCustomTabs: List<String>? = null,
): CustomTabsIntent {
  setCustomTabsPackage(context, false, additionalCustomTabs)
  return this
}

private fun CustomTabsIntent.setCustomTabsPackage(
  context: Context,
  ignoreDefault: Boolean = true,
  additionalCustomTabs: List<String>? = null,
) {
  getCustomTabsPackage(context, ignoreDefault, additionalCustomTabs)?.let { packageName ->
    intent.setPackage(packageName)
  }
}

/**
 * Retrieves the appropriate browser package name that supports Custom Tabs.
 *
 * This function builds a list of eligible browser packages by combining the default
 * Chrome packages with any additional packages provided by [additionalCustomTabs].
 * It then uses the [CustomTabsClient] to determine the best package to handle Custom Tabs.
 *
 * @param context The source Context
 * @param ignoreDefault If set to `true`, the default browser is prioritized when selecting the Custom Tabs package.
 * @param additionalCustomTabs Additional browser packages that support Custom Tabs.
 *
 * @return The package name of the selected browser that supports Custom Tabs, or `null` if none found.
 */
fun getCustomTabsPackage(
  context: Context,
  ignoreDefault: Boolean = true,
  additionalCustomTabs: List<String>? = null,
): String? {
  val packages = buildList {
    addAll(CHROME_PACKAGES)
    additionalCustomTabs?.let { addAll(it) }
  }
  return CustomTabsClient.getPackageName(context, packages, ignoreDefault)
}
