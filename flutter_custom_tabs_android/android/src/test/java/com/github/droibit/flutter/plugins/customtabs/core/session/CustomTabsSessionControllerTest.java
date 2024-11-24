package com.github.droibit.flutter.plugins.customtabs.core.session;

import static com.google.common.truth.Truth.assertThat;
import static org.junit.Assert.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.content.ComponentName;
import android.content.Context;

import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsSession;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.robolectric.annotation.Config;

@RunWith(AndroidJUnit4.class)
@Config(manifest = Config.NONE)
public class CustomTabsSessionControllerTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private Context context;

    @InjectMocks
    private CustomTabsSessionController controller;

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
        controller.bindCustomTabsService(context, "com.example");
        controller.unbindCustomTabsService();

        assertThat(controller.isCustomTabsServiceBound()).isFalse();
        assertThat(controller.getSession()).isNull();
        verify(context).unbindService(controller);
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
}