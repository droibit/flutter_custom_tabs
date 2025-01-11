package com.github.droibit.flutter.plugins.customtabs.core

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Browser.EXTRA_HEADERS
import androidx.annotation.VisibleForTesting
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions
import com.github.droibit.flutter.plugins.customtabs.core.utils.bundleOf

class ExternalBrowserLauncher {
    fun launch(context: Context, uri: Uri, options: CustomTabsIntentOptions?): Boolean {
        val externalBrowserIntent = createIntent(options) ?: return false
        externalBrowserIntent.setData(uri)
        context.startActivity(externalBrowserIntent)
        return true
    }

    @VisibleForTesting
    internal fun createIntent(options: CustomTabsIntentOptions?): Intent? {
        val intent = Intent(Intent.ACTION_VIEW)
        if (options == null) {
            return intent
        }

        val browserOptions = options.browser ?: return null
        val prefersExternalBrowser = browserOptions.prefersExternalBrowser
        if (prefersExternalBrowser == true) {
            browserOptions.headers?.let { intent.putExtra(EXTRA_HEADERS, bundleOf(it)) }
            return intent
        }
        return null
    }
}
