package com.github.droibit.flutter.plugins.customtabs.core.options

import com.google.common.truth.Truth.assertThat
import com.google.testing.junit.testparameterinjector.TestParameter
import com.google.testing.junit.testparameterinjector.TestParameterInjector
import com.google.testing.junit.testparameterinjector.TestParameters
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(TestParameterInjector::class)
class CustomTabsSessionOptionsBuilderTest {
    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "prefersDefaultBrowser" to true,
            "fallbackCustomTabs" to listOf(
                "com.example.browser1",
                "com.example.browser2",
            )
        )

        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setOptions(options)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isTrue()
        assertThat(sessionOptions.fallbackCustomTabPackages).containsExactly(
            "com.example.browser1",
            "com.example.browser2",
        )
    }

    @Test
    fun setOptions_withNullOptions() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setOptions(null)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun setPrefersDefaultBrowser_parameterized(
        @TestParameter("true", "false", "null") input: Boolean?
    ) {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setPrefersDefaultBrowser(input)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isEqualTo(input)
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    @TestParameters("{input: ['com.example.browser1']}", customName = "Multiple packages")
    @TestParameters("{input: []}", customName = "Empty packages")
    @TestParameters("{input: null}", customName = "Null packages")
    fun setFallbackCustomTabs_parameterized(input: List<String>?) {
        val inputSet = input?.toSet()
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setFallbackCustomTabs(inputSet)
            .build()

        assertThat(sessionOptions.fallbackCustomTabPackages).isEqualTo(inputSet)
    }

    @Test
    fun build_withChainedMethods() {
        val animations = CustomTabsAnimations.Builder()
            .setStartEnter("fade_in")
            .setStartExit("fade_out")
            .setEndEnter("slide_in")
            .setEndExit("slide_out")
            .build()

        assertThat(animations.startEnter).isEqualTo("fade_in")
        assertThat(animations.startExit).isEqualTo("fade_out")
        assertThat(animations.endEnter).isEqualTo("slide_in")
        assertThat(animations.endExit).isEqualTo("slide_out")
    }
}