package com.github.droibit.android.customtabs.launcher

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.google.common.truth.Truth.assertThat
import org.junit.Assert.assertThrows
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class NonChromeCustomTabsTest {
  @Test
  fun `init throws exception if packages contain Chrome package`() {
    val packages = setOf("com.android.chrome", "com.example.customtabs_1")
    assertThrows(
      "Packages must not contain any Chrome packages.",
      IllegalArgumentException::class.java,
    ) {
      NonChromeCustomTabs(packages)
    }
  }

  @Test
  fun `invoke returns non-Chrome packages`() {
    val packages = setOf(
      "com.example.customtabs_1",
      "com.example.customtabs_2",
    )
    val provider = NonChromeCustomTabs(packages)
    assertThat(provider()).isEqualTo(packages)
  }

  @Test
  fun `invoke returns empty set if no non-Chrome packages`() {
    val provider = NonChromeCustomTabs(emptySet())
    assertThat(provider()).isEmpty()
  }
}
