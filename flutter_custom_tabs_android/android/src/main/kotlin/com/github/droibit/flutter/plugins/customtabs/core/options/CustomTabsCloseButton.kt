package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.browser.customtabs.CustomTabsIntent.CloseButtonPosition

class CustomTabsCloseButton internal constructor(
  val icon: String?,
  @CloseButtonPosition val position: Int?
) {
  class Builder {
    private var icon: String? = null
    private var position: Int? = null

    fun setOptions(options: Map<String, Any>?): Builder {
      if (options == null) {
        return this
      }
      icon = options[KEY_ICON] as String?
      position = (options[KEY_POSITION] as Long?)?.toInt()
      return this
    }

    fun setIcon(icon: String?): Builder {
      this.icon = icon
      return this
    }

    fun setPosition(position: Int?): Builder {
      this.position = position
      return this
    }

    fun build() = CustomTabsCloseButton(icon, position)

    private companion object {
      private const val KEY_ICON = "icon"
      private const val KEY_POSITION = "position"
    }
  }
}
