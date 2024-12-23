package com.github.droibit.flutter.plugins.customtabs.core

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.os.Build
import androidx.annotation.RequiresApi

/**
 * ref. [Let native applications handle the content](https://developer.chrome.com/docs/android/custom-tabs/howto-custom-tab-native-apps/)
 */
class NativeAppLauncher {
    fun launch(context: Context, uri: Uri): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            launchNativeApi30(context, uri)
        } else {
            launchNativeBeforeApi30(context, uri)
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.R)
    private fun launchNativeApi30(context: Context, uri: Uri): Boolean {
        val nativeAppIntent = Intent(Intent.ACTION_VIEW, uri)
            .addCategory(Intent.CATEGORY_BROWSABLE)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REQUIRE_NON_BROWSER)
        try {
            context.startActivity(nativeAppIntent)
            return true
        } catch (ignored: ActivityNotFoundException) {
            return false
        }
    }

    private fun launchNativeBeforeApi30(context: Context, uri: Uri): Boolean {
        val pm = context.packageManager

        // Get all Apps that resolve a generic url
        val browserActivityIntent = Intent()
            .setAction(Intent.ACTION_VIEW)
            .addCategory(Intent.CATEGORY_BROWSABLE)
            .setData(Uri.fromParts(uri.scheme, "", null))
        val genericResolvedList: Set<String> = extractPackageNames(
            queryIntentActivities(pm, browserActivityIntent)
        )

        // Get all apps that resolve the specific Url
        val specializedActivityIntent = Intent(Intent.ACTION_VIEW, uri)
            .addCategory(Intent.CATEGORY_BROWSABLE)
        val resolvedSpecializedList = buildSet {
            addAll(
                extractPackageNames(queryIntentActivities(pm, specializedActivityIntent))
            )
            // Keep only the Urls that resolve the specific, but not the generic urls.
            removeAll(genericResolvedList)
        }
        // If the list is empty, no native app handlers were found.
        if (resolvedSpecializedList.isEmpty()) {
            return false
        }

        // We found native handlers. Launch the Intent.
        specializedActivityIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(specializedActivityIntent)
        return true
    }

    @Suppress("deprecation")
    private fun queryIntentActivities(pm: PackageManager, intent: Intent): List<ResolveInfo> {
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PackageManager.MATCH_ALL
        } else {
            PackageManager.MATCH_DEFAULT_ONLY
        }

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.queryIntentActivities(
                intent,
                PackageManager.ResolveInfoFlags.of(flags.toLong())
            )
        } else {
            pm.queryIntentActivities(intent, flags)
        }
    }

    private fun extractPackageNames(resolveInfo: List<ResolveInfo>): Set<String> {
        return buildSet(resolveInfo.size) {
            for (info in resolveInfo) {
                add(info.activityInfo.packageName)
            }
        }
    }
}
