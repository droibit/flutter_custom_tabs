package com.github.droibit.flutter.plugins.customtabs.core.utils

import android.os.Bundle

internal fun bundleOf(headers: Map<String, String>): Bundle {
  return Bundle(headers.size).apply {
    for ((key, value) in headers) {
      putString(key, value)
    }
  }
}