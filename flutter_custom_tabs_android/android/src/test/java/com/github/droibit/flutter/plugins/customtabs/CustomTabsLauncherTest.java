package com.github.droibit.flutter.plugins.customtabs;

import static androidx.test.ext.truth.content.IntentSubject.assertThat;
import static com.google.common.truth.Truth.assertThat;
import static org.junit.Assert.fail;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.same;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;

import androidx.browser.customtabs.CustomTabsIntent;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import com.github.droibit.flutter.plugins.customtabs.Messages.FlutterError;
import com.github.droibit.flutter.plugins.customtabs.core.IntentFactory;
import com.github.droibit.flutter.plugins.customtabs.core.NativeAppLauncher;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.robolectric.annotation.Config;

import java.util.Collections;
import java.util.Map;

@RunWith(AndroidJUnit4.class)
@Config(manifest = Config.NONE)
public class CustomTabsLauncherTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private IntentFactory customTabsFactory;

    @Mock
    private NativeAppLauncher nativeAppLauncher;

    @InjectMocks
    private CustomTabsLauncher launcher;

    @Test
    public void launchWithoutActivity() {
        launcher.setActivity(null);

        try {
            launcher.launch("https://example.com", false, null);
            fail("error");
        } catch (Exception e) {
            assertThat(e).isInstanceOf(FlutterError.class);

            final FlutterError actualError = ((FlutterError) e);
            assertThat(actualError.code).isEqualTo(CustomTabsLauncher.CODE_LAUNCH_ERROR);
        }
    }

    @Test
    public void launchNativeAppSuccess() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        when(nativeAppLauncher.launch(any(), any())).thenReturn(true);

        try {
            final String expUrl = "https://example.com";
            launcher.launch(expUrl, true, null);

            verify(nativeAppLauncher).launch(same(activity), eq(Uri.parse(expUrl)));
        } catch (Exception e) {
            fail(e.getMessage());
        }

        verify(customTabsFactory, never()).createExternalBrowserIntent(any());
        verify(customTabsFactory, never()).createCustomTabsIntent(any(), any());
    }

    @Test
    public void launchExternalBrowserSuccess() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final Intent externalBrowserIntent = new Intent();
        when(customTabsFactory.createExternalBrowserIntent(any())).thenReturn(externalBrowserIntent);

        try {
            final String expUrl = "https://example.com";
            launcher.launch(expUrl, false, null);

            final ArgumentCaptor<Intent> intentCaptor = ArgumentCaptor.forClass(Intent.class);
            verify(activity).startActivity(intentCaptor.capture());

            final Intent actualIntent = intentCaptor.getValue();
            assertThat(actualIntent).hasData(Uri.parse(expUrl));
        } catch (Exception e) {
            fail(e.getMessage());
        }

        verify(customTabsFactory, never()).createCustomTabsIntent(any(), any());
    }

    @Test
    public void launchExternalBrowserFailure() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final Intent externalBrowserIntent = new Intent();
        when(customTabsFactory.createExternalBrowserIntent(any())).thenReturn(externalBrowserIntent);

        final ActivityNotFoundException anf = mock(ActivityNotFoundException.class);
        doThrow(anf).when(activity).startActivity(any());

        try {
            launcher.launch("https://example.com", false, null);
            fail("error");
        } catch (Exception e) {
            assertThat(e).isInstanceOf(FlutterError.class);

            final FlutterError actualError = ((FlutterError) e);
            assertThat(actualError.code).isEqualTo(CustomTabsLauncher.CODE_LAUNCH_ERROR);
        }
    }


    @Test
    public void launchPartialCustomTabsSuccess() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        when(customTabsFactory.createExternalBrowserIntent(any())).thenReturn(null);

        final CustomTabsIntent customTabsIntent = new CustomTabsIntent.Builder()
                .setInitialActivityHeightPx(100)
                .build();
        when(customTabsFactory.createCustomTabsIntent(any(), any())).thenReturn(customTabsIntent);

        try {
            final String expUrl = "https://example.com";
            final Map<String, Object> options = Collections.emptyMap();
            launcher.launch(expUrl, false, options);

            final ArgumentCaptor<Intent> intentCaptor = ArgumentCaptor.forClass(Intent.class);
            verify(activity).startActivityForResult(intentCaptor.capture(), anyInt());

            final Intent actualIntent = intentCaptor.getValue();
            assertThat(actualIntent).hasData(Uri.parse(expUrl));
            assertThat(actualIntent).isSameInstanceAs(customTabsIntent.intent);
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void launchCustomTabsSuccess() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        when(customTabsFactory.createExternalBrowserIntent(any())).thenReturn(null);

        final CustomTabsIntent customTabsIntent = spy(new CustomTabsIntent.Builder().build());
        when(customTabsFactory.createCustomTabsIntent(any(), any())).thenReturn(customTabsIntent);

        try {
            final String expUrl = "https://example.com";
            final Map<String, Object> options = Collections.emptyMap();
            launcher.launch(expUrl, false, options);

            final ArgumentCaptor<Uri> urlCaptor = ArgumentCaptor.forClass(Uri.class);
            verify(customTabsIntent).launchUrl(any(), urlCaptor.capture());

            final Uri actualUrl = urlCaptor.getValue();
            assertThat(actualUrl).isEqualTo(Uri.parse(expUrl));
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void launchCustomTabsFailure() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        when(customTabsFactory.createExternalBrowserIntent(any())).thenReturn(null);

        final CustomTabsIntent customTabsIntent = spy(new CustomTabsIntent.Builder().build());
        when(customTabsFactory.createCustomTabsIntent(any(), any())).thenReturn(customTabsIntent);

        final ActivityNotFoundException anf = mock(ActivityNotFoundException.class);
        doThrow(anf).when(customTabsIntent).launchUrl(any(), any());

        try {
            final Map<String, Object> options = Collections.emptyMap();
            launcher.launch("https://example.com", false, options);
            fail("error");
        } catch (Exception e) {
            assertThat(e).isInstanceOf(FlutterError.class);

            final FlutterError actualError = ((FlutterError) e);
            assertThat(actualError.code).isEqualTo(CustomTabsLauncher.CODE_LAUNCH_ERROR);
        }
    }
}