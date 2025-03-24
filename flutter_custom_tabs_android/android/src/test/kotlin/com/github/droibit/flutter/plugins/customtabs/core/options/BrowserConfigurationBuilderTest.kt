package com.github.droibit.flutter.plugins.customtabs.core.options

import com.google.common.truth.Truth.assertThat
import org.junit.Test

class BrowserConfigurationBuilderTest {
    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "prefersExternalBrowser" to true,
            "prefersDefaultBrowser" to false,
            "fallbackCustomTabs" to listOf("com.example.browser1", "com.example.browser2"),
            "headers" to mapOf("key1" to "value1", "key2" to "value2"),
            "sessionPackageName" to "com.example.session"
        )

        val config = BrowserConfiguration.Builder()
            .setOptions(options)
            .build()

        assertThat(config.prefersExternalBrowser).isTrue()
        assertThat(config.prefersDefaultBrowser).isFalse()
        assertThat(config.fallbackCustomTabPackages).containsExactly(
            "com.example.browser1",
            "com.example.browser2"
        )
        assertThat(config.headers).containsExactly("key1", "value1", "key2", "value2")
        assertThat(config.sessionPackageName).isEqualTo("com.example.session")
    }

    @Test
    fun setOptions_withNullOptions() {
        val config = BrowserConfiguration.Builder()
            .setOptions(null)
            .build()

        assertThat(config.prefersExternalBrowser).isNull()
        assertThat(config.prefersDefaultBrowser).isNull()
        assertThat(config.fallbackCustomTabPackages).isNull()
        assertThat(config.headers).isNull()
        assertThat(config.sessionPackageName).isNull()
    }

    @Test
    fun setOptions_withPartialOptions() {
        val options = mapOf(
            "prefersExternalBrowser" to true,
            "headers" to mapOf("key" to "value")
        )

        val config = BrowserConfiguration.Builder()
            .setOptions(options)
            .build()

        assertThat(config.prefersExternalBrowser).isTrue()
        assertThat(config.prefersDefaultBrowser).isNull()
        assertThat(config.fallbackCustomTabPackages).isNull()
        assertThat(config.headers).containsExactly("key", "value")
        assertThat(config.sessionPackageName).isNull()
    }

    @Test
    fun setOptions_withEmptyOptions() {
        val config = BrowserConfiguration.Builder()
            .setOptions(emptyMap())
            .build()

        assertThat(config.prefersExternalBrowser).isNull()
        assertThat(config.prefersDefaultBrowser).isNull()
        assertThat(config.fallbackCustomTabPackages).isNull()
        assertThat(config.headers).isNull()
        assertThat(config.sessionPackageName).isNull()
    }

    @Test
    fun setPrefersExternalBrowser_withTrue() {
        val config = BrowserConfiguration.Builder()
            .setPrefersExternalBrowser(true)
            .build()

        assertThat(config.prefersExternalBrowser).isTrue()
    }

    @Test
    fun setPrefersExternalBrowser_withFalse() {
        val config = BrowserConfiguration.Builder()
            .setPrefersExternalBrowser(false)
            .build()

        assertThat(config.prefersExternalBrowser).isFalse()
    }

    @Test
    fun setPrefersExternalBrowser_withNull() {
        val config = BrowserConfiguration.Builder()
            .setPrefersExternalBrowser(null)
            .build()

        assertThat(config.prefersExternalBrowser).isNull()
    }

    @Test
    fun setPrefersDefaultBrowser_withTrue() {
        val config = BrowserConfiguration.Builder()
            .setPrefersDefaultBrowser(true)
            .build()

        assertThat(config.prefersDefaultBrowser).isTrue()
    }

    @Test
    fun setPrefersDefaultBrowser_withFalse() {
        val config = BrowserConfiguration.Builder()
            .setPrefersDefaultBrowser(false)
            .build()

        assertThat(config.prefersDefaultBrowser).isFalse()
    }

    @Test
    fun setPrefersDefaultBrowser_withNull() {
        val config = BrowserConfiguration.Builder()
            .setPrefersDefaultBrowser(null)
            .build()

        assertThat(config.prefersDefaultBrowser).isNull()
    }

    @Test
    fun setFallbackCustomTabs_withMultiplePackages() {
        val packages = setOf("com.example.browser1", "com.example.browser2")

        val config = BrowserConfiguration.Builder()
            .setFallbackCustomTabs(packages)
            .build()

        assertThat(config.fallbackCustomTabPackages).containsExactlyElementsIn(packages)
    }

    @Test
    fun setFallbackCustomTabs_withEmptySet() {
        val config = BrowserConfiguration.Builder()
            .setFallbackCustomTabs(emptySet())
            .build()

        assertThat(config.fallbackCustomTabPackages).isEmpty()
    }

    @Test
    fun setFallbackCustomTabs_withNull() {
        val config = BrowserConfiguration.Builder()
            .setFallbackCustomTabs(null)
            .build()

        assertThat(config.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun setHeaders_withMultipleEntries() {
        val headers = mapOf("key1" to "value1", "key2" to "value2")

        val config = BrowserConfiguration.Builder()
            .setHeaders(headers)
            .build()

        assertThat(config.headers).containsExactlyEntriesIn(headers)
    }

    @Test
    fun setHeaders_withEmptyMap() {
        val config = BrowserConfiguration.Builder()
            .setHeaders(emptyMap())
            .build()

        assertThat(config.headers).isEmpty()
    }

    @Test
    fun setHeaders_withNull() {
        val config = BrowserConfiguration.Builder()
            .setHeaders(null)
            .build()

        assertThat(config.headers).isNull()
    }

    @Test
    fun setSessionPackageName_withValidPackageName() {
        val packageName = "com.example.session"

        val config = BrowserConfiguration.Builder()
            .setSessionPackageName(packageName)
            .build()

        assertThat(config.sessionPackageName).isEqualTo(packageName)
    }

    @Test
    fun setSessionPackageName_withEmptyString() {
        val config = BrowserConfiguration.Builder()
            .setSessionPackageName("")
            .build()

        assertThat(config.sessionPackageName).isEmpty()
    }

    @Test
    fun setSessionPackageName_withNull() {
        val config = BrowserConfiguration.Builder()
            .setSessionPackageName(null)
            .build()

        assertThat(config.sessionPackageName).isNull()
    }

    @Test
    fun build_withChainedMethods() {
        val config = BrowserConfiguration.Builder()
            .setPrefersExternalBrowser(true)
            .setPrefersDefaultBrowser(false)
            .setFallbackCustomTabs(setOf("com.example.browser"))
            .setHeaders(mapOf("key" to "value"))
            .setSessionPackageName("com.example.session")
            .build()

        assertThat(config.prefersExternalBrowser).isTrue()
        assertThat(config.prefersDefaultBrowser).isFalse()
        assertThat(config.fallbackCustomTabPackages).containsExactly("com.example.browser")
        assertThat(config.headers).containsExactly("key", "value")
        assertThat(config.sessionPackageName).isEqualTo("com.example.session")
    }

    @Test
    fun build_withoutSettingAnyOptions() {
        val config = BrowserConfiguration.Builder().build()

        assertThat(config.prefersExternalBrowser).isNull()
        assertThat(config.prefersDefaultBrowser).isNull()
        assertThat(config.fallbackCustomTabPackages).isNull()
        assertThat(config.headers).isNull()
        assertThat(config.sessionPackageName).isNull()
    }
}