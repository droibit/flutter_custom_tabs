package com.github.droibit.flutter.plugins.customtabs.core;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Browser;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import com.github.droibit.flutter.plugins.customtabs.core.options.BrowserConfiguration;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions;

import java.util.Map;

public class ExternalBrowserLauncher {
    public ExternalBrowserLauncher() {
    }

    public boolean launch(
            @NonNull Context context,
            @NonNull Uri uri,
            @Nullable CustomTabsIntentOptions options
    ) {
        final Intent externalBrowserIntent = createIntent(options);
        if (externalBrowserIntent == null) {
            return false;
        }

        externalBrowserIntent.setData(uri);
        context.startActivity(externalBrowserIntent);
        return true;
    }

    @VisibleForTesting
    @Nullable
    Intent createIntent(@Nullable CustomTabsIntentOptions options) {
        final Intent intent = new Intent(Intent.ACTION_VIEW);
        if (options == null) {
            return intent;
        }

        final BrowserConfiguration browserOptions = options.getBrowser();
        if (browserOptions == null || !browserOptions.getPrefersExternalBrowser()) {
            return null;
        }

        final Map<String, String> headers = browserOptions.getHeaders();
        if (headers != null) {
            final Bundle bundleHeaders = extractBundle(headers);
            intent.putExtra(Browser.EXTRA_HEADERS, bundleHeaders);
        }
        return intent;
    }

    private @NonNull Bundle extractBundle(@NonNull Map<String, String> headers) {
        final Bundle dest = new Bundle(headers.size());
        for (Map.Entry<String, String> entry : headers.entrySet()) {
            dest.putString(entry.getKey(), entry.getValue());
        }
        return dest;
    }
}
