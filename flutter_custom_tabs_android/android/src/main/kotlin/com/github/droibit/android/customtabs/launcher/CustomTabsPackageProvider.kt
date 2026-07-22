package com.github.droibit.android.customtabs.launcher

import android.content.Context
import androidx.browser.customtabs.CustomTabsIntent
import com.github.droibit.android.customtabs.launcher.CustomTabsPackage.CHROME_PACKAGES

/**
 * Interface for providing a set of browser package names that support Custom Tabs.
 *
 * The [CustomTabsPackageProvider] interface allows you to specify alternative browsers
 * that can handle Custom Tabs when launching URLs using [CustomTabsIntent].
 * This is particularly useful when the default browser does not support Custom Tabs
 * or when Chrome is not installed on the device.
 */
fun interface CustomTabsPackageProvider {
  /**
   * Retrieves the set of browser package names that support Custom Tabs.
   *
   * @return A [Set] of package names as [String].
   */
  operator fun invoke(): Set<String>
}

/**
 * Provides a set of non-Chrome browser package names that support Custom Tabs.
 *
 * This is useful when Chrome is not installed or when you prefer to use a different browser
 * that supports Custom Tabs.
 *
 * @param packages Package list of non-Chrome browsers supporting Custom Tabs. The top of the list is used with the highest priority.
 */
class NonChromeCustomTabs(
  private val packages: Set<String>,
) : CustomTabsPackageProvider {

  constructor(context: Context) : this(
    CustomTabsPackage.getNonChromeCustomTabsPackages(context),
  )

  init {
    require(packages.none { CHROME_PACKAGES.contains(it) }) {
      "Packages must not contain any Chrome packages."
    }
  }

  override operator fun invoke(): Set<String> = packages
}
