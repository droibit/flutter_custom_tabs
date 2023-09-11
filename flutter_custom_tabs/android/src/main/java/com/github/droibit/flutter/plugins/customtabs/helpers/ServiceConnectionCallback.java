package com.github.droibit.flutter.plugins.customtabs;

import androidx.browser.customtabs.CustomTabsClient;

/**
 * Callback for events when connecting and disconnecting from Custom Tabs Service.
 *
 * Source: https://github.com/GoogleChrome/android-browser-helper/tree/main/demos/custom-tabs-example-app
 */
public interface ServiceConnectionCallback {
    /**
     * Called when the service is connected.
     * @param client a CustomTabsClient
     */
    void onServiceConnected(CustomTabsClient client);

    /**
     * Called when the service is disconnected.
     */
    void onServiceDisconnected();
}
