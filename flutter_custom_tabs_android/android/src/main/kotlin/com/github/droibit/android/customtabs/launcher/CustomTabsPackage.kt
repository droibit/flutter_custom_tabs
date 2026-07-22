package com.github.droibit.android.customtabs.launcher

import android.content.Context
import android.content.Intent
import android.content.Intent.ACTION_VIEW
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.os.Build
import androidx.browser.customtabs.CustomTabsService
import androidx.core.net.toUri

object CustomTabsPackage {
  private const val PACKAGE_CHROME_STABLE = "com.android.chrome"
  private const val PACKAGE_CHROME_BETA = "com.chrome.beta"
  private const val PACKAGE_CHROME_DEV = "com.chrome.dev"
  private const val PACKAGE_CHROME_LOCAL = "com.google.android.apps.chrome"

  // Higher priority packages are listed first.
  val CHROME_PACKAGES = setOf(
    PACKAGE_CHROME_STABLE,
    PACKAGE_CHROME_BETA,
    PACKAGE_CHROME_DEV,
    PACKAGE_CHROME_LOCAL,
  )

  fun getNonChromeCustomTabsPackages(context: Context): Set<String> {
    val activityIntent = Intent(ACTION_VIEW, "http://".toUri())
      .addCategory(Intent.CATEGORY_BROWSABLE)
    val pm = context.packageManager
    return queryIntentActivities(pm, activityIntent)
      .asSequence()
      .map { it.activityInfo.packageName }
      .filter { it !in CHROME_PACKAGES }
      .filter {
        val serviceIntent = Intent(CustomTabsService.ACTION_CUSTOM_TABS_CONNECTION)
          .setPackage(it)
        pm.resolveService(serviceIntent, 0) != null
      }
      .toSet()
  }

  private fun queryIntentActivities(pm: PackageManager, intent: Intent): List<ResolveInfo> {
    val flag = PackageManager.MATCH_ALL
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      pm.queryIntentActivities(
        intent,
        PackageManager.ResolveInfoFlags.of(flag.toLong()),
      )
    } else {
      pm.queryIntentActivities(intent, flag)
    }
  }
}
