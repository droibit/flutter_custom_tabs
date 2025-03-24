package com.github.droibit.flutter.plugins.customtabs.core.options

import com.google.common.truth.Truth.assertThat
import org.junit.Test

class CustomTabsAnimationsBuilderTest {
    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "startEnter" to "fade_in",
            "startExit" to "fade_out",
            "endEnter" to "slide_in",
            "endExit" to "slide_out"
        )

        val animations = CustomTabsAnimations.Builder()
            .setOptions(options)
            .build()

        assertThat(animations.startEnter).isEqualTo("fade_in")
        assertThat(animations.startExit).isEqualTo("fade_out")
        assertThat(animations.endEnter).isEqualTo("slide_in")
        assertThat(animations.endExit).isEqualTo("slide_out")
    }

    @Test
    fun setOptions_withPartialOptions() {
        val options = mapOf(
            "startEnter" to "fade_in",
            "endExit" to "slide_out"
        )

        val animations = CustomTabsAnimations.Builder()
            .setOptions(options)
            .build()

        assertThat(animations.startEnter).isEqualTo("fade_in")
        assertThat(animations.startExit).isNull()
        assertThat(animations.endEnter).isNull()
        assertThat(animations.endExit).isEqualTo("slide_out")
    }

    @Test
    fun setOptions_withEmptyMap() {
        val animations = CustomTabsAnimations.Builder()
            .setOptions(emptyMap())
            .build()

        assertThat(animations.startEnter).isNull()
        assertThat(animations.startExit).isNull()
        assertThat(animations.endEnter).isNull()
        assertThat(animations.endExit).isNull()
    }

    @Test
    fun setOptions_withNull() {
        val animations = CustomTabsAnimations.Builder()
            .setOptions(null)
            .build()

        assertThat(animations.startEnter).isNull()
        assertThat(animations.startExit).isNull()
        assertThat(animations.endEnter).isNull()
        assertThat(animations.endExit).isNull()
    }

    @Test
    fun setStartEnter_withValidValue() {
        val animations = CustomTabsAnimations.Builder()
            .setStartEnter("fade_in")
            .build()

        assertThat(animations.startEnter).isEqualTo("fade_in")
        assertThat(animations.startExit).isNull()
        assertThat(animations.endEnter).isNull()
        assertThat(animations.endExit).isNull()
    }

    @Test
    fun setStartExit_withValidValue() {
        val animations = CustomTabsAnimations.Builder()
            .setStartExit("fade_out")
            .build()

        assertThat(animations.startEnter).isNull()
        assertThat(animations.startExit).isEqualTo("fade_out")
        assertThat(animations.endEnter).isNull()
        assertThat(animations.endExit).isNull()
    }

    @Test
    fun setEndEnter_withValidValue() {
        val animations = CustomTabsAnimations.Builder()
            .setEndEnter("slide_in")
            .build()

        assertThat(animations.startEnter).isNull()
        assertThat(animations.startExit).isNull()
        assertThat(animations.endEnter).isEqualTo("slide_in")
        assertThat(animations.endExit).isNull()
    }

    @Test
    fun setEndExit_withValidValue() {
        val animations = CustomTabsAnimations.Builder()
            .setEndExit("slide_out")
            .build()

        assertThat(animations.startEnter).isNull()
        assertThat(animations.startExit).isNull()
        assertThat(animations.endEnter).isNull()
        assertThat(animations.endExit).isEqualTo("slide_out")
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

    @Test
    fun build_withoutSettingAnyOptions() {
        val animations = CustomTabsAnimations.Builder().build()

        assertThat(animations.startEnter).isNull()
        assertThat(animations.startExit).isNull()
        assertThat(animations.endEnter).isNull()
        assertThat(animations.endExit).isNull()
    }
}