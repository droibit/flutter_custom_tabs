package com.github.droibit.flutter.plugins.customtabs.core.utils

import android.os.Bundle

internal const val TAG = "CustomTabsAndroid"

internal fun extractBundle(headers: Map<String, String>): Bundle {
    return Bundle(headers.size).apply {
        for ((key, value) in headers) {
            putString(key, value)
        }
    }
}