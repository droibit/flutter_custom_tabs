package com.github.droibit.flutter.plugins.customtabs.core

import android.app.Activity
import android.net.Uri
import androidx.browser.customtabs.CustomTabsIntent
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_INITIAL_ACTIVITY_HEIGHT_PX

class PartialCustomTabsLauncher {
    fun launch(activity: Activity, uri: Uri, customTabsIntent: CustomTabsIntent): Boolean {
        val rawIntent = customTabsIntent.intent
        if (rawIntent.hasExtra(EXTRA_INITIAL_ACTIVITY_HEIGHT_PX) &&
            rawIntent.hasExtra(EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR)
        ) {
            // ref. https://developer.chrome.com/docs/android/custom-tabs/guide-partial-custom-tabs
            rawIntent.setData(uri)
            activity.startActivityForResult(rawIntent, REQUEST_CODE_PARTIAL_CUSTOM_TABS)
            return true
        }
        return false
    }

    private companion object {
        const val REQUEST_CODE_PARTIAL_CUSTOM_TABS = 1001
    }
}
