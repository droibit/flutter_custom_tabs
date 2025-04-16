package com.github.droibit.flutter.plugins.customtabs

import android.app.Activity
import android.app.ActivityManager
import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP
import android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.os.Build
import androidx.annotation.RestrictTo
import androidx.annotation.VisibleForTesting
import androidx.browser.customtabs.CustomTabsService.ACTION_CUSTOM_TABS_CONNECTION
import androidx.core.content.getSystemService
import androidx.core.net.toUri
import com.github.droibit.flutter.plugins.customtabs.core.CustomTabsIntentFactory
import com.github.droibit.flutter.plugins.customtabs.core.ExternalBrowserLauncher
import com.github.droibit.flutter.plugins.customtabs.core.NativeAppLauncher
import com.github.droibit.flutter.plugins.customtabs.core.PartialCustomTabsLauncher
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionManager

@RestrictTo(RestrictTo.Scope.LIBRARY)
internal class CustomTabsLauncher @VisibleForTesting constructor(
  private val customTabsIntentFactory: CustomTabsIntentFactory,
  private val customTabsSessionManager: CustomTabsSessionManager,
  private val nativeAppLauncher: NativeAppLauncher,
  private val externalBrowserLauncher: ExternalBrowserLauncher,
  private val partialCustomTabsLauncher: PartialCustomTabsLauncher
) : CustomTabsApi {
  private var activity: Activity? = null

  constructor() : this(
    CustomTabsIntentFactory(),
    CustomTabsSessionManager(),
    NativeAppLauncher(),
    ExternalBrowserLauncher(),
    PartialCustomTabsLauncher()
  )

  fun setActivity(activity: Activity?) {
    customTabsSessionManager.handleActivityChange(activity)
    this.activity = activity
  }

  override fun launch(
    urlString: String,
    prefersDeepLink: Boolean,
    options: Map<String, Any>?
  ) {
    val activity = this.activity
      ?: throw FlutterError(
        CODE_LAUNCH_ERROR,
        "Launching a Custom Tab requires a foreground activity.",
        null
      )

    val uri = urlString.toUri()
    if (prefersDeepLink && nativeAppLauncher.launch(activity, uri)) {
      return
    }

    try {
      val customTabsOptions = customTabsIntentFactory.createIntentOptions(options)
      if (externalBrowserLauncher.launch(activity, uri, customTabsOptions)) {
        return
      }

      val customTabsIntent = customTabsIntentFactory.createIntent(
        activity,
        requireNotNull(customTabsOptions),
        customTabsSessionManager
      )
      if (partialCustomTabsLauncher.launch(activity, uri, customTabsIntent)) {
        return
      }
      customTabsIntent.launchUrl(activity, uri)
    } catch (e: ActivityNotFoundException) {
      throw FlutterError(CODE_LAUNCH_ERROR, e.message, null)
    }
  }

  override fun closeAllIfPossible() {
    val activity = this.activity ?: return
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      return
    }

    val am = activity.getSystemService<ActivityManager>()
    val selfActivityName = ComponentName(activity, activity.javaClass)
    for (appTask in requireNotNull(am).appTasks) {
      val taskInfo = appTask.taskInfo
      if (selfActivityName != taskInfo.baseActivity || taskInfo.topActivity == null) {
        continue
      }

      val serviceIntent = Intent(ACTION_CUSTOM_TABS_CONNECTION)
        .setPackage(taskInfo.topActivity?.packageName)
      if (resolveService(activity.packageManager, serviceIntent) != null) {
        try {
          val intent = Intent(activity, activity.javaClass)
            .setFlags(FLAG_ACTIVITY_CLEAR_TOP or FLAG_ACTIVITY_SINGLE_TOP)
          activity.startActivity(intent)
        } catch (ignored: ActivityNotFoundException) {
        }
        break
      }
    }
  }

  override fun warmup(options: Map<String, Any>?): String? {
    val activity = this.activity ?: return null

    val sessionOptions = customTabsSessionManager.createSessionOptions(options)
    val sessionController =
      customTabsSessionManager.createSessionController(activity, sessionOptions)
        ?: return null

    return if (sessionController.bindCustomTabsService(activity)) {
      sessionController.packageName
    } else {
      null
    }
  }

  override fun mayLaunch(urls: List<String>, sessionPackageName: String) {
    val controller = customTabsSessionManager.getSessionController(sessionPackageName) ?: return
    controller.mayLaunchUrls(urls)
  }

  override fun invalidate(sessionPackageName: String) {
    customTabsSessionManager.invalidateSession(sessionPackageName)
  }

  /**
   * @noinspection SameParameterValue
   */
  @Suppress("deprecation")
  private fun resolveService(
    pm: PackageManager,
    intent: Intent,
    flags: Int = 0
  ): ResolveInfo? {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      pm.resolveService(
        intent,
        PackageManager.ResolveInfoFlags.of(flags.toLong())
      )
    } else {
      pm.resolveService(intent, flags)
    }
  }

  private companion object {
    const val CODE_LAUNCH_ERROR = "LAUNCH_ERROR"
  }
}
