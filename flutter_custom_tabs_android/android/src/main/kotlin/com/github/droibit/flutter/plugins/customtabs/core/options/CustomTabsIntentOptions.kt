package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.browser.customtabs.CustomTabsIntent.ShareState

class CustomTabsIntentOptions private constructor(
    val colorSchemes: CustomTabsColorSchemes?,
    val urlBarHidingEnabled: Boolean?,
    @ShareState val shareState: Int?,
    val showTitle: Boolean?,
    val instantAppsEnabled: Boolean?,
    val bookmarksButtonEnabled: Boolean?,
    val downloadButtonEnabled: Boolean?,
    val shareIdentityEnabled: Boolean?,
    val closeButton: CustomTabsCloseButton?,
    val animations: CustomTabsAnimations?,
    val browser: BrowserConfiguration?,
    val partial: PartialCustomTabsConfiguration?
) {
    class Builder {
        private var colorSchemes: CustomTabsColorSchemes? = null
        private var urlBarHidingEnabled: Boolean? = null
        private var shareState: Int? = null
        private var showTitle: Boolean? = null
        private var instantAppsEnabled: Boolean? = null
        private var bookmarksButtonEnabled: Boolean? = null
        private var downloadButtonEnabled: Boolean? = null
        private var shareIdentityEnabled: Boolean? = null
        private var closeButton: CustomTabsCloseButton? = null
        private var animations: CustomTabsAnimations? = null
        private var browser: BrowserConfiguration? = null
        private var partial: PartialCustomTabsConfiguration? = null

        /**
         * @noinspection DataFlowIssue
         */
        @Suppress("UNCHECKED_CAST")
        fun setOptions(options: Map<String, Any>?): Builder {
            if (options == null) {
                return this
            }

            colorSchemes = CustomTabsColorSchemes.Builder()
                .setOptions((options[KEY_COLOR_SCHEMES] as Map<String, Any>?))
                .build()
            urlBarHidingEnabled = options[KEY_URL_BAR_HIDING_ENABLED] as Boolean?
            shareState = (options[KEY_SHARE_STATE] as Long?)?.toInt()
            showTitle = options[KEY_SHOW_TITLE] as Boolean?
            instantAppsEnabled = options[KEY_INSTANT_APPS_ENABLED] as Boolean?
            bookmarksButtonEnabled = options[KEY_BOOKMARKS_BUTTON_ENABLED] as Boolean?
            downloadButtonEnabled = options[KEY_DOWNLOAD_BUTTON_ENABLED] as Boolean?
            shareIdentityEnabled = options[KEY_SHARE_IDENTITY_ENABLED] as Boolean?
            closeButton = CustomTabsCloseButton.Builder()
                .setOptions((options[KEY_CLOSE_BUTTON] as Map<String, Any>?))
                .build()
            animations = CustomTabsAnimations.Builder()
                .setOptions(options[KEY_ANIMATIONS] as Map<String, Any>?)
                .build()
            browser = BrowserConfiguration.Builder()
                .setOptions(options[KEY_BROWSER] as Map<String, Any>?)
                .build()
            partial = PartialCustomTabsConfiguration.Builder()
                .setOptions(options[KEY_PARTIAL] as Map<String, Any>?)
                .build()
            return this
        }

        fun setColorSchemes(colorSchemes: CustomTabsColorSchemes?): Builder {
            this.colorSchemes = colorSchemes
            return this
        }

        fun setUrlBarHidingEnabled(urlBarHidingEnabled: Boolean?): Builder {
            this.urlBarHidingEnabled = urlBarHidingEnabled
            return this
        }

        fun setShareState(@ShareState shareState: Int?): Builder {
            this.shareState = shareState
            return this
        }

        fun setShowTitle(showTitle: Boolean?): Builder {
            this.showTitle = showTitle
            return this
        }

        fun setInstantAppsEnabled(instantAppsEnabled: Boolean?): Builder {
            this.instantAppsEnabled = instantAppsEnabled
            return this
        }

        fun setBookmarksButtonEnabled(bookmarksButtonEnabled: Boolean?): Builder {
            this.bookmarksButtonEnabled = bookmarksButtonEnabled
            return this
        }

        fun setDownloadButtonEnabled(downloadButtonEnabled: Boolean?): Builder {
            this.downloadButtonEnabled = downloadButtonEnabled
            return this
        }

        fun setShareIdentityEnabled(shareIdentityEnabled: Boolean?): Builder {
            this.shareIdentityEnabled = shareIdentityEnabled
            return this
        }

        fun setCloseButton(closeButton: CustomTabsCloseButton?): Builder {
            this.closeButton = closeButton
            return this
        }

        fun setAnimations(animations: CustomTabsAnimations?): Builder {
            this.animations = animations
            return this
        }

        fun setBrowser(browser: BrowserConfiguration?): Builder {
            this.browser = browser
            return this
        }

        fun setPartial(partial: PartialCustomTabsConfiguration?): Builder {
            this.partial = partial
            return this
        }

        fun build() = CustomTabsIntentOptions(
            colorSchemes = colorSchemes,
            urlBarHidingEnabled = urlBarHidingEnabled,
            shareState = shareState,
            showTitle = showTitle,
            instantAppsEnabled = instantAppsEnabled,
            bookmarksButtonEnabled = bookmarksButtonEnabled,
            downloadButtonEnabled = downloadButtonEnabled,
            shareIdentityEnabled = shareIdentityEnabled,
            closeButton = closeButton,
            animations = animations,
            browser = browser,
            partial = partial,
        )

        private companion object {
            private const val KEY_COLOR_SCHEMES = "colorSchemes"
            private const val KEY_URL_BAR_HIDING_ENABLED = "urlBarHidingEnabled"
            private const val KEY_SHARE_STATE = "shareState"
            private const val KEY_SHOW_TITLE = "showTitle"
            private const val KEY_INSTANT_APPS_ENABLED = "instantAppsEnabled"
            private const val KEY_BOOKMARKS_BUTTON_ENABLED = "bookmarksButtonEnabled"
            private const val KEY_DOWNLOAD_BUTTON_ENABLED = "downloadButtonEnabled"
            private const val KEY_SHARE_IDENTITY_ENABLED = "shareIdentityEnabled"
            private const val KEY_CLOSE_BUTTON = "closeButton"
            private const val KEY_ANIMATIONS = "animations"
            private const val KEY_BROWSER = "browser"
            private const val KEY_PARTIAL = "partial"
        }
    }
}
