package com.github.droibit.flutter.plugins.customtabs;

import static com.google.common.truth.Truth.assertThat;
import static org.junit.Assert.fail;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.ArgumentMatchers.same;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.net.Uri;

import androidx.browser.customtabs.CustomTabsIntent;
import androidx.core.util.Pair;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import com.github.droibit.flutter.plugins.customtabs.Messages.FlutterError;
import com.github.droibit.flutter.plugins.customtabs.core.CustomTabsIntentFactory;
import com.github.droibit.flutter.plugins.customtabs.core.ExternalBrowserLauncher;
import com.github.droibit.flutter.plugins.customtabs.core.NativeAppLauncher;
import com.github.droibit.flutter.plugins.customtabs.core.PartialCustomTabsLauncher;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsSessionOptions;
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionController;
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionManager;

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
    private CustomTabsIntentFactory customTabsIntentFactory;

    @Mock
    private NativeAppLauncher nativeAppLauncher;

    @Mock
    private ExternalBrowserLauncher externalBrowserLauncher;

    @Mock
    private PartialCustomTabsLauncher partialCustomTabsLauncher;

    @Mock
    private CustomTabsSessionManager customTabsSessionManager;

    @InjectMocks
    private CustomTabsLauncher launcher;

    @Test
    public void launch_withoutActivity_throwsException() {
        launcher.setActivity(null);

        try {
            launcher.launch("https://example.com", false, null);
            fail("error");
        } catch (Exception e) {
            assertThat(e).isInstanceOf(FlutterError.class);

            final FlutterError actualError = ((FlutterError) e);
            assertThat(actualError.code).isEqualTo(CustomTabsLauncher.CODE_LAUNCH_ERROR);
        }

        verify(nativeAppLauncher, never()).launch(any(), any());
    }

    @Test
    public void launch_withNativeApp() {
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

        verify(externalBrowserLauncher, never()).launch(any(), any(), any());
        verify(customTabsIntentFactory, never()).createIntent(any(), any(), any());
    }

    @Test
    public void launch_withExternalBrowser() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        when(customTabsIntentFactory.createIntentOptions(any())).thenReturn(null);
        when(externalBrowserLauncher.launch(any(), any(), any())).thenReturn(true);

        try {
            final Uri expUrl = Uri.parse("https://example.com");
            launcher.launch(expUrl.toString(), false, null);

            verify(externalBrowserLauncher).launch(any(), eq(expUrl), isNull());
            verify(customTabsIntentFactory, never()).createIntent(any(), any(), any());
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void launch_withExternalBrowser_throwsException() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        when(customTabsIntentFactory.createIntentOptions(any())).thenReturn(null);

        final ActivityNotFoundException anf = mock(ActivityNotFoundException.class);
        doThrow(anf).when(externalBrowserLauncher).launch(any(), any(), any());

        final Uri uri = Uri.parse("https://example.com");
        try {
            launcher.launch(uri.toString(), false, null);
            fail("error");
        } catch (Exception e) {
            assertThat(e).isInstanceOf(FlutterError.class);

            final FlutterError actualError = ((FlutterError) e);
            assertThat(actualError.code).isEqualTo(CustomTabsLauncher.CODE_LAUNCH_ERROR);
        }

        verify(externalBrowserLauncher).launch(any(), eq(uri), isNull());
        verify(customTabsIntentFactory, never()).createIntent(any(), any(), any());
    }

    @Test
    public void launch_withPartialCustomTabs() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final CustomTabsIntentOptions intentOptions = mock(CustomTabsIntentOptions.class);
        when(customTabsIntentFactory.createIntentOptions(any())).thenReturn(intentOptions);
        when(externalBrowserLauncher.launch(any(), any(), any())).thenReturn(false);

        final CustomTabsIntent customTabsIntent = spy(
                new CustomTabsIntent.Builder()
                        .setInitialActivityHeightPx(100)
                        .build()
        );
        when(customTabsIntentFactory.createIntent(any(), any(), any())).thenReturn(customTabsIntent);
        when(partialCustomTabsLauncher.launch(any(), any(), any())).thenReturn(true);

        try {
            final String expUrl = "https://example.com";
            final Map<String, Object> options = Collections.emptyMap();
            launcher.launch(expUrl, false, options);

            verify(customTabsIntentFactory).createIntent(any(), same(intentOptions), any());
            verify(partialCustomTabsLauncher).launch(any(), any(), same(customTabsIntent));
            verify(customTabsIntent, never()).launchUrl(any(), any());
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void launch_withPartialCustomTabs_throwsException() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final CustomTabsIntentOptions intentOptions = mock(CustomTabsIntentOptions.class);
        when(customTabsIntentFactory.createIntentOptions(any())).thenReturn(intentOptions);
        when(externalBrowserLauncher.launch(any(), any(), any())).thenReturn(false);

        final CustomTabsIntent customTabsIntent = new CustomTabsIntent.Builder()
                .setInitialActivityHeightPx(100)
                .build();
        when(customTabsIntentFactory.createIntent(any(), any(), any())).thenReturn(customTabsIntent);

        final ActivityNotFoundException anf = mock(ActivityNotFoundException.class);
        doThrow(anf).when(partialCustomTabsLauncher).launch(any(), any(), any());

        try {
            final String expUrl = "https://example.com";
            final Map<String, Object> options = Collections.emptyMap();
            launcher.launch(expUrl, false, options);
            fail("error");
        } catch (Exception e) {
            assertThat(e).isInstanceOf(FlutterError.class);

            final FlutterError actualError = ((FlutterError) e);
            assertThat(actualError.code).isEqualTo(CustomTabsLauncher.CODE_LAUNCH_ERROR);
        }

        verify(customTabsIntentFactory).createIntent(any(), same(intentOptions), any());
        verify(partialCustomTabsLauncher).launch(any(), any(), same(customTabsIntent));
    }

    @Test
    public void launch_withCustomTabs() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final CustomTabsIntentOptions intentOptions = mock(CustomTabsIntentOptions.class);
        when(customTabsIntentFactory.createIntentOptions(any())).thenReturn(intentOptions);
        when(externalBrowserLauncher.launch(any(), any(), any())).thenReturn(false);

        final CustomTabsIntent customTabsIntent = spy(new CustomTabsIntent.Builder().build());
        when(customTabsIntentFactory.createIntent(any(), any(), any())).thenReturn(customTabsIntent);
        when(partialCustomTabsLauncher.launch(any(), any(), any())).thenReturn(false);

        try {
            final String expUrl = "https://example.com";
            final Map<String, Object> options = Collections.emptyMap();
            launcher.launch(expUrl, false, options);

            final ArgumentCaptor<Uri> urlCaptor = ArgumentCaptor.forClass(Uri.class);
            verify(customTabsIntent).launchUrl(any(), urlCaptor.capture());

            final Uri actualUrl = urlCaptor.getValue();
            assertThat(actualUrl).isEqualTo(Uri.parse(expUrl));

            verify(customTabsIntentFactory).createIntent(any(), same(intentOptions), any());
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void launch_withCustomTabs_throwsException() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final CustomTabsIntentOptions intentOptions = mock(CustomTabsIntentOptions.class);
        when(customTabsIntentFactory.createIntentOptions(any())).thenReturn(intentOptions);
        when(externalBrowserLauncher.launch(any(), any(), any())).thenReturn(false);

        final CustomTabsIntent customTabsIntent = spy(new CustomTabsIntent.Builder().build());
        when(customTabsIntentFactory.createIntent(any(), any(), any())).thenReturn(customTabsIntent);

        final ActivityNotFoundException anf = mock(ActivityNotFoundException.class);
        doThrow(anf).when(customTabsIntent).launchUrl(any(), any());

        when(partialCustomTabsLauncher.launch(any(), any(), any())).thenReturn(false);

        try {
            final Map<String, Object> options = Collections.emptyMap();
            launcher.launch("https://example.com", false, options);
            fail("error");
        } catch (Exception e) {
            assertThat(e).isInstanceOf(FlutterError.class);

            final FlutterError actualError = ((FlutterError) e);
            assertThat(actualError.code).isEqualTo(CustomTabsLauncher.CODE_LAUNCH_ERROR);
        }

        verify(customTabsIntentFactory).createIntent(any(), same(intentOptions), any());
    }

    @Test
    public void warmup_withSessionOptions_returnsPackageName() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final CustomTabsSessionOptions sessionOptions = mock(CustomTabsSessionOptions.class);
        when(customTabsSessionManager.createSessionOptions(any())).thenReturn(sessionOptions);

        final String expectedPackageName = "com.example.browser";
        final CustomTabsSessionController controller = mock(CustomTabsSessionController.class);
        when(controller.getPackageName()).thenReturn(expectedPackageName);
        when(controller.bindCustomTabsService(any())).thenReturn(true);

        when(customTabsSessionManager.createSessionController(any(), any()))
                .thenReturn(controller);

        final Map<String, Object> options = Collections.emptyMap();
        final String actualPackageName = launcher.warmup(options);
        assertThat(actualPackageName).isEqualTo(expectedPackageName);

        verify(customTabsSessionManager).createSessionOptions(same(options));
        verify(controller).bindCustomTabsService(any());
    }

    @Test
    public void warmup_withSessionOptions_returnsNull() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final CustomTabsSessionOptions sessionOptions = mock(CustomTabsSessionOptions.class);
        when(customTabsSessionManager.createSessionOptions(any())).thenReturn(sessionOptions);

        when(customTabsSessionManager.createSessionController(any(), any()))
                .thenReturn(null);

        final Map<String, Object> options = Collections.emptyMap();
        final String actualPackageName = launcher.warmup(options);
        assertThat(actualPackageName).isNull();

        verify(customTabsSessionManager).createSessionOptions(same(options));
    }

    @Test
    public void warmup_withSessionOptions_bindCustomTabsServiceReturnsFalse() {
        final Activity activity = mock(Activity.class);
        launcher.setActivity(activity);

        final CustomTabsSessionOptions sessionOptions = mock(CustomTabsSessionOptions.class);
        when(customTabsSessionManager.createSessionOptions(any())).thenReturn(sessionOptions);

        final CustomTabsSessionController controller = mock(CustomTabsSessionController.class);
        when(controller.bindCustomTabsService(any())).thenReturn(false);

        when(customTabsSessionManager.createSessionController(any(), any()))
                .thenReturn(controller);

        final Map<String, Object> options = Collections.emptyMap();
        final String actualPackageName = launcher.warmup(options);
        assertThat(actualPackageName).isNull();

        verify(customTabsSessionManager).createSessionOptions(same(options));
        verify(controller).bindCustomTabsService(any());
    }

    @Test
    public void warmup_withoutActivity_returnsNull() {
        launcher.setActivity(null);

        final String actualPackageName = launcher.warmup(Collections.emptyMap());
        assertThat(actualPackageName).isNull();

        verify(customTabsSessionManager, never()).createSessionOptions(any());
        verify(customTabsSessionManager, never()).createSessionController(any(), any());
    }

    @Test
    public void invalidate_withValidPackageName_invokesInvalidateSession() throws Exception {
        final String packageName = "com.example.browser";
        launcher.invalidate(packageName);

        verify(customTabsSessionManager).invalidateSession(eq(packageName));
    }
}