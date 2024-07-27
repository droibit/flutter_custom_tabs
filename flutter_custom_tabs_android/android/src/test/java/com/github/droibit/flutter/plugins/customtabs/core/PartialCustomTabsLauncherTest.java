package com.github.droibit.flutter.plugins.customtabs.core;

import static androidx.test.ext.truth.content.IntentSubject.assertThat;
import static com.google.common.truth.Truth.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.same;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

import android.app.Activity;
import android.net.Uri;

import androidx.browser.customtabs.CustomTabsIntent;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.robolectric.annotation.Config;

@RunWith(AndroidJUnit4.class)
@Config(manifest = Config.NONE)
public class PartialCustomTabsLauncherTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private Activity activity;

    @InjectMocks
    private PartialCustomTabsLauncher launcher;

    @Test
    public void launch_withValidCustomTabsIntent_returnsTrue() {
        final CustomTabsIntent customTabsIntent = new CustomTabsIntent.Builder()
                .setInitialActivityHeightPx(100)
                .build();

        final Uri uri = Uri.parse("https://example.com");
        final boolean result = launcher.launch(activity, uri, customTabsIntent);
        assertThat(result).isTrue();
        assertThat(customTabsIntent.intent).hasData(uri);
        verify(activity).startActivityForResult(same(customTabsIntent.intent), eq(1001));
    }

    @Test
    public void launch_withoutRequiredExtras_returnsFalse() {
        final CustomTabsIntent customTabsIntent = new CustomTabsIntent.Builder()
                .build();

        final Uri uri = Uri.parse("https://example.com");
        final boolean result = launcher.launch(activity, uri, customTabsIntent);
        assertThat(result).isFalse();

        verify(activity, never()).startActivityForResult(any(), anyInt());
    }
}