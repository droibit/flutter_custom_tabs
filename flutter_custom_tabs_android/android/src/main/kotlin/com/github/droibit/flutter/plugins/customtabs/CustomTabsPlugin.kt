package com.github.droibit.flutter.plugins.customtabs

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CustomTabsPlugin : FlutterPlugin, ActivityAware {
    private var api: CustomTabsLauncher? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        api = CustomTabsLauncher()
        CustomTabsApi.setUp(binding.binaryMessenger, api)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        if (api == null) {
            return
        }

        CustomTabsApi.setUp(binding.binaryMessenger, null)
        api = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val api = this.api ?: return
        api.setActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        val api = this.api ?: return
        api.setActivity(null)
    }
}
