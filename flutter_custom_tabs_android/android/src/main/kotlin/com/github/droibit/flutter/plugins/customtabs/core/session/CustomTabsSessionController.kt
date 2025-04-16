package com.github.droibit.flutter.plugins.customtabs.core.session

import android.content.ComponentName
import android.content.Context
import androidx.annotation.VisibleForTesting
import androidx.browser.customtabs.CustomTabsClient
import androidx.browser.customtabs.CustomTabsService.KEY_URL
import androidx.browser.customtabs.CustomTabsServiceConnection
import androidx.browser.customtabs.CustomTabsSession
import androidx.core.net.toUri
import androidx.core.os.bundleOf
import io.flutter.Log

class CustomTabsSessionController(
  val packageName: String
) : CustomTabsServiceConnection() {
  private var context: Context? = null

  @set:VisibleForTesting
  internal var session: CustomTabsSession? = null

  @get:VisibleForTesting
  var isCustomTabsServiceBound: Boolean = false
    private set

  fun bindCustomTabsService(context: Context): Boolean {
    if (isCustomTabsServiceBound) {
      Log.d(TAG, "Custom Tab($packageName) already bound.")
      return true
    }
    return tryBindCustomTabsService(context)
  }

  private fun tryBindCustomTabsService(context: Context): Boolean {
    try {
      val bound = CustomTabsClient.bindCustomTabsService(context, packageName, this)
      Log.d(TAG, "Custom Tab($packageName) bound: $bound")
      if (bound) {
        this.context = context
      }
      isCustomTabsServiceBound = bound
    } catch (e: SecurityException) {
      isCustomTabsServiceBound = false
    }
    return isCustomTabsServiceBound
  }

  fun unbindCustomTabsService() {
    context?.unbindService(this)
    session = null
    isCustomTabsServiceBound = false
    Log.d(TAG, "Custom Tab($packageName) unbound.")
  }

  override fun onCustomTabsServiceConnected(name: ComponentName, client: CustomTabsClient) {
    val warmedUp = client.warmup(0)
    Log.d(TAG, "Custom Tab(${name.packageName}) warmedUp: " + warmedUp)
    session = client.newSession(null)
  }

  override fun onServiceDisconnected(name: ComponentName) {
    session = null
    isCustomTabsServiceBound = false

    Log.d(TAG, "Custom Tab($packageName) disconnected.")
  }

  fun mayLaunchUrls(urls: List<String>) {
    val session = this.session
    if (session == null) {
      Log.w(TAG, "Custom Tab session is null. Cannot may launch URL(s).")
      return
    }
    if (urls.isEmpty()) {
      Log.w(TAG, "URLs is empty. Cannot may launch URL(s).")
      return
    }

    if (urls.size == 1) {
      val succeeded = session.mayLaunchUrl(urls[0].toUri(), null, null)
      Log.d(TAG, "May launch URL: $succeeded")
      return
    }

    val bundles = urls.map { bundleOf(KEY_URL to it.toUri()) }
    val succeeded = session.mayLaunchUrl(null, null, bundles)
    Log.d(TAG, "May launch URL(s): $succeeded")
  }

  private companion object {
    private const val TAG = "CustomTabsAndroid"
  }
}
