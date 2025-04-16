package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.browser.customtabs.CustomTabsIntent.CLOSE_BUTTON_POSITION_START
import com.google.common.truth.Truth.assertThat
import com.google.testing.junit.testparameterinjector.TestParameter
import com.google.testing.junit.testparameterinjector.TestParameterInjector
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(TestParameterInjector::class)
class CustomTabsCloseButtonBuilderTest {
  @Test
  fun build_withChainedMethods() {
    val closeButton = CustomTabsCloseButton.Builder()
      .setIcon("ic_arrow_back")
      .setPosition(CLOSE_BUTTON_POSITION_START)
      .build()

    assertThat(closeButton.icon).isEqualTo("ic_arrow_back")
    assertThat(closeButton.position).isEqualTo(CLOSE_BUTTON_POSITION_START)
  }

  @Test
  fun setOptions_withAllOptions() {
    val options = mapOf(
      "icon" to "ic_arrow_back",
      "position" to CLOSE_BUTTON_POSITION_START.toLong(),
    )

    val closeButton = CustomTabsCloseButton.Builder()
      .setOptions(options)
      .build()

    assertThat(closeButton.icon).isEqualTo("ic_arrow_back")
    assertThat(closeButton.position).isEqualTo(CLOSE_BUTTON_POSITION_START)
  }

  @Test
  fun setOptions_withNullOptions() {
    val closeButton = CustomTabsCloseButton.Builder()
      .setOptions(null)
      .build()

    assertThat(closeButton.icon).isNull()
    assertThat(closeButton.position).isNull()
  }

  @Test
  fun setIcon_parameterized(
    @TestParameter("ic_arrow_back", "null") input: String?
  ) {
    val closeButton = CustomTabsCloseButton.Builder()
      .setIcon(input)
      .build()

    assertThat(closeButton.icon).isEqualTo(input)
  }

  @Test
  fun setPosition_parameterized(
    @TestParameter("1", "null") input: Int?
  ) {
    val closeButton = CustomTabsCloseButton.Builder()
      .setPosition(input)
      .build()

    assertThat(closeButton.position).isEqualTo(input)
  }
}