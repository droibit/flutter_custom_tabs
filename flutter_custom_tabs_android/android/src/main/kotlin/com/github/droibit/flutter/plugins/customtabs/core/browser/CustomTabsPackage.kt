package com.github.droibit.flutter.plugins.customtabs.core.browser

import android.content.Context
import android.content.Intent
import android.content.Intent.ACTION_VIEW
import androidx.browser.customtabs.CustomTabsService
import androidx.core.net.toUri
import com.github.droibit.flutter.plugins.customtabs.core.utils.queryIntentActivitiesCompat

object CustomTabsPackage {
  private const val PACKAGE_CHROME_STABLE = "com.android.chrome"
  private const val PACKAGE_CHROME_BETA = "com.chrome.beta"
  private const val PACKAGE_CHROME_DEV = "com.chrome.dev"
  private const val PACKAGE_CHROME_LOCAL = "com.google.android.apps.chrome"

  // Higher priority packages are listed first.
  val CHROME_PACKAGES: Set<String> = linkedSetOf(
    PACKAGE_CHROME_STABLE,
    PACKAGE_CHROME_BETA,
    PACKAGE_CHROME_DEV,
    PACKAGE_CHROME_LOCAL,
  )

  fun getNonChromeCustomTabsPackages(context: Context): List<String> {
    val activityIntent = Intent(ACTION_VIEW, "http://".toUri())
      .addCategory(Intent.CATEGORY_BROWSABLE)
    val pm = context.packageManager
    return pm.queryIntentActivitiesCompat(activityIntent)
      .asSequence()
      .map { it.activityInfo.packageName }
      .filter { it !in CHROME_PACKAGES }
      .filter {
        val serviceIntent = Intent(CustomTabsService.ACTION_CUSTOM_TABS_CONNECTION)
          .setPackage(it)
        pm.resolveService(serviceIntent, 0) != null
      }
      .toList()
  }
}
