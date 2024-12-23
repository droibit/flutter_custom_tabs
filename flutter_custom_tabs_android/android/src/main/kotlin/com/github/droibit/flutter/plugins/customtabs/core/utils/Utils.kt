package com.github.droibit.flutter.plugins.customtabs.core.utils

import android.os.Bundle

internal const val TAG = "CustomTabsAndroid"

internal const val CODE_LAUNCH_ERROR: String = "LAUNCH_ERROR"
internal const val REQUEST_CODE_PARTIAL_CUSTOM_TABS = 1001

internal fun extractBundle(headers: Map<String, String>): Bundle {
    return Bundle(headers.size).apply {
        for ((key, value) in headers) {
            putString(key, value)
        }
    }
}