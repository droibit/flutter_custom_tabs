package com.github.droibit.flutter.plugins.customtabs.core.session;

import static androidx.browser.customtabs.CustomTabsService.KEY_URL;
import static androidx.test.ext.truth.os.BundleSubject.assertThat;
import static com.google.common.truth.Truth.assertThat;
import static org.junit.Assert.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.content.ComponentName;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsSession;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.MockedStatic;
import org.robolectric.annotation.Config;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@RunWith(AndroidJUnit4.class)
@Config(manifest = Config.NONE)
public class CustomTabsSessionControllerTest {
    private final String packageName = "com.example.browser";

    private CustomTabsSessionController controller;

    @Before
    public void setUp() throws Exception {
        controller = new CustomTabsSessionController(packageName);
    }

    @Test
    public void bindCustomTabsService_withValidPackageName_returnsTrue() {
        try (MockedStatic<CustomTabsClient> mocked = mockStatic(CustomTabsClient.class)) {
            mocked.when(() -> CustomTabsClient.bindCustomTabsService(any(), anyString(), any()))
                    .thenReturn(true);

            final Context context = mock(Context.class);
            final boolean result = controller.bindCustomTabsService(context);
            assertThat(result).isTrue();
            assertThat(controller.isCustomTabsServiceBound()).isTrue();

            mocked.verify(
                    () -> CustomTabsClient.bindCustomTabsService(any(), eq(packageName), any())
            );
        }
    }

    @Test
    public void bindCustomTabsService_withInvalidPackageName_returnsFalse() {
        try (MockedStatic<CustomTabsClient> mocked = mockStatic(CustomTabsClient.class)) {
            mocked.when(() -> CustomTabsClient.bindCustomTabsService(any(), anyString(), any()))
                    .thenReturn(false);

            final Context context = mock(Context.class);
            final boolean result = controller.bindCustomTabsService(context);
            assertThat(result).isFalse();
            assertThat(controller.isCustomTabsServiceBound()).isFalse();

            mocked.verify(
                    () -> CustomTabsClient.bindCustomTabsService(any(), eq(packageName), any())
            );
        }
    }

    @Test
    public void bindCustomTabsService_withSecurityException_returnsFalse() {
        try (MockedStatic<CustomTabsClient> mocked = mockStatic(CustomTabsClient.class)) {
            mocked.when(() -> CustomTabsClient.bindCustomTabsService(any(), anyString(), any()))
                    .thenThrow(new SecurityException());

            final Context context = mock(Context.class);
            final boolean result = controller.bindCustomTabsService(context);
            assertThat(result).isFalse();
            assertThat(controller.isCustomTabsServiceBound()).isFalse();

            mocked.verify(
                    () -> CustomTabsClient.bindCustomTabsService(any(), eq(packageName), any())
            );
        }
    }

    @Test
    public void unbindCustomTabsService_whenBound_unbindsService() {
        try (MockedStatic<CustomTabsClient> mocked = mockStatic(CustomTabsClient.class)) {
            mocked.when(() -> CustomTabsClient.bindCustomTabsService(any(), anyString(), any()))
                    .thenReturn(true);

            final Context context = mock(Context.class);
            controller.bindCustomTabsService(context);
            controller.unbindCustomTabsService();

            assertThat(controller.isCustomTabsServiceBound()).isFalse();
            assertThat(controller.getSession()).isNull();
            verify(context).unbindService(controller);
        }
    }

    @Test
    public void onCustomTabsServiceConnected_setsSession() {
        final CustomTabsClient client = mock(CustomTabsClient.class);
        final CustomTabsSession session = mock(CustomTabsSession.class);
        when(client.newSession(any())).thenReturn(session);

        final ComponentName name = new ComponentName("com.example", "CustomTabsService");
        controller.onCustomTabsServiceConnected(name, client);

        assertNotNull(controller.getSession());
    }

    @Test
    public void onServiceDisconnected_clearsSession() {
        final ComponentName name = new ComponentName("com.example", "CustomTabsService");
        controller.onServiceDisconnected(name);

        assertThat(controller.getSession()).isNull();
        assertThat(controller.isCustomTabsServiceBound()).isFalse();
    }

    @Test
    public void mayLaunchUrls_withSessionAndSingleUrl_callsMayLaunchUrl() {
        final CustomTabsSession session = mock(CustomTabsSession.class);
        controller.setSession(session);

        when(session.mayLaunchUrl(any(), any(), any()))
                .thenReturn(true);

        final String url = "https://example.com";
        controller.mayLaunchUrls(Collections.singletonList(url));

        verify(session).mayLaunchUrl(eq(Uri.parse(url)), isNull(), isNull());
    }

    @SuppressWarnings("unchecked")
    @Test
    public void mayLaunchUrls_withSessionAndMultipleUrls_callsMayLaunchUrlWithBundles() {
        final CustomTabsSession session = mock(CustomTabsSession.class);
        controller.setSession(session);
        when(session.mayLaunchUrl(any(), any(), any())).thenReturn(true);

        final String url1 = "https://example.com";
        final String url2 = "https://flutter.dev";
        controller.mayLaunchUrls(Arrays.asList(url1, url2));

        final ArgumentCaptor<List<Bundle>> captor = ArgumentCaptor.forClass(List.class);
        verify(session).mayLaunchUrl(
                isNull(),
                isNull(),
                captor.capture()
        );
        final List<Bundle> bundles = captor.getValue();
        assertThat(bundles).hasSize(2);

        final Bundle bundle1 = bundles.get(0);
        assertThat(bundle1).parcelable(KEY_URL).isEqualTo(Uri.parse(url1));

        final Bundle bundle2 = bundles.get(1);
        assertThat(bundle2).parcelable(KEY_URL).isEqualTo(Uri.parse(url2));
    }

    @Test
    public void mayLaunchUrls_withNullSession_logsWarning() {
        controller.setSession(null);

        final String url = "https://example.com";
        controller.mayLaunchUrls(Collections.singletonList(url));

        // Since session is null, mayLaunchUrl should not be called
        // We verify that session remains null and no exception is thrown
        assertThat(controller.getSession()).isNull();
    }

    @Test
    public void mayLaunchUrls_withEmptyUrlList_logsWarning() {
        final CustomTabsSession session = mock(CustomTabsSession.class);
        controller.setSession(session);

        controller.mayLaunchUrls(Collections.emptyList());

        verify(session, never()).mayLaunchUrl(any(), any(), any());
    }
}