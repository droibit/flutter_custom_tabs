package com.github.droibit.flutter.plugins.customtabs.core.options

import com.google.common.truth.Truth.assertThat
import com.google.testing.junit.testparameterinjector.TestParameter
import com.google.testing.junit.testparameterinjector.TestParameterInjector
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(TestParameterInjector::class)
class CustomTabsAnimationsBuilderTest {
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
  fun setOptions_withNullOptions() {
    val animations = CustomTabsAnimations.Builder()
      .setOptions(null)
      .build()

    assertThat(animations.startEnter).isNull()
    assertThat(animations.startExit).isNull()
    assertThat(animations.endEnter).isNull()
    assertThat(animations.endExit).isNull()
  }

  @Test
  fun setStartEnter_parameterized(
    @TestParameter("fade_in", "null") input: String?
  ) {
    val animations = CustomTabsAnimations.Builder()
      .setStartEnter(input)
      .build()

    assertThat(animations.startEnter).isEqualTo(input)
    assertThat(animations.startExit).isNull()
    assertThat(animations.endEnter).isNull()
    assertThat(animations.endExit).isNull()
  }

  @Test
  fun setStartExit_parameterized(
    @TestParameter("fade_out", "null") input: String?
  ) {
    val animations = CustomTabsAnimations.Builder()
      .setStartExit(input)
      .build()

    assertThat(animations.startEnter).isNull()
    assertThat(animations.startExit).isEqualTo(input)
    assertThat(animations.endEnter).isNull()
    assertThat(animations.endExit).isNull()
  }

  @Test
  fun setEndEnter_parameterized(
    @TestParameter("slide_in", "null") input: String?
  ) {
    val animations = CustomTabsAnimations.Builder()
      .setEndEnter(input)
      .build()

    assertThat(animations.startEnter).isNull()
    assertThat(animations.startExit).isNull()
    assertThat(animations.endEnter).isEqualTo(input)
    assertThat(animations.endExit).isNull()
  }

  @Test
  fun setEndExit_parameterized(
    @TestParameter("slide_out", "null") input: String?
  ) {
    val animations = CustomTabsAnimations.Builder()
      .setEndExit(input)
      .build()

    assertThat(animations.startEnter).isNull()
    assertThat(animations.startExit).isNull()
    assertThat(animations.endEnter).isNull()
    assertThat(animations.endExit).isEqualTo(input)
  }
}