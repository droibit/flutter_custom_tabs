package com.github.droibit.flutter.plugins.customtabs.core.utils

import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.os.Build

internal fun PackageManager.queryIntentActivitiesCompat(
  intent: Intent,
  flags: Int = PackageManager.MATCH_ALL
): List<ResolveInfo> {
  return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
    queryIntentActivities(intent, PackageManager.ResolveInfoFlags.of(flags.toLong()))
  } else {
    @Suppress("DEPRECATION")
    queryIntentActivities(intent, flags)
  }
}