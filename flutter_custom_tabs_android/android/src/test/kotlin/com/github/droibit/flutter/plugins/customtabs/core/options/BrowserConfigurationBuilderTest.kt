package com.github.droibit.flutter.plugins.customtabs.core.options

import com.google.common.truth.Truth.assertThat
import com.google.testing.junit.testparameterinjector.TestParameter
import com.google.testing.junit.testparameterinjector.TestParameterInjector
import com.google.testing.junit.testparameterinjector.TestParameters
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(TestParameterInjector::class)
class BrowserConfigurationBuilderTest {
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
    fun setPrefersExternalBrowser_parameterized(
        @TestParameter("true", "false", "null") input: Boolean?
    ) {
        val config = BrowserConfiguration.Builder()
            .setPrefersExternalBrowser(input)
            .build()
        assertThat(config.prefersExternalBrowser).isEqualTo(input)
    }

    @Test
    fun setPrefersDefaultBrowser_parameterized(
        @TestParameter("true", "false", "null") input: Boolean?
    ) {
        val config = BrowserConfiguration.Builder()
            .setPrefersDefaultBrowser(input)
            .build()
        assertThat(config.prefersDefaultBrowser).isEqualTo(input)
    }

    @Test
    @TestParameters("{input: ['example.browser1','browser2']}", customName = "Multiple packages")
    @TestParameters("{input: []}", customName = "Empty packages")
    @TestParameters("{input: null}", customName = "Null packages")
    fun setFallbackCustomTabs_parameterized(input: List<String>?) {
        val inputSet = input?.toSet()
        val config = BrowserConfiguration.Builder()
            .setFallbackCustomTabs(inputSet)
            .build()
        assertThat(config.fallbackCustomTabPackages).isEqualTo(inputSet)
    }

    @Test
    @TestParameters("{input: {key1: 'key1', key2: 'value2'}}", customName = "Multiple entries")
    @TestParameters("{input: {}}", customName = "No entries")
    @TestParameters("{input: null}", customName = "Null entries")
    fun setHeaders_parameterized(input: Map<String, String>?) {
        val config = BrowserConfiguration.Builder()
            .setHeaders(input)
            .build()
        assertThat(config.headers).isEqualTo(input)
    }

    @Test
    fun setSessionPackageName_parameterized(
        @TestParameter("com.example.session", "", "null") input: String?
    ) {
        val config = BrowserConfiguration.Builder()
            .setSessionPackageName(input)
            .build()

        assertThat(config.sessionPackageName).isEqualTo(input)
    }
}