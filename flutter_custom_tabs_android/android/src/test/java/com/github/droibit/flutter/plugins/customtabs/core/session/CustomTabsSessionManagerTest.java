package com.github.droibit.flutter.plugins.customtabs.core.session;

import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.getCustomTabsPackage;
import static com.google.common.truth.Truth.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.anyBoolean;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.content.Context;

import androidx.browser.customtabs.CustomTabsSession;
import androidx.core.util.Pair;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import com.droibit.android.customtabs.launcher.CustomTabsIntentHelper;
import com.droibit.android.customtabs.launcher.CustomTabsPackageProvider;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsSessionOptions;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockedStatic;
import org.robolectric.annotation.Config;

import java.util.HashMap;
import java.util.Map;

@RunWith(AndroidJUnit4.class)
@Config(manifest = Config.NONE)
public class CustomTabsSessionManagerTest {
    private Map<String, CustomTabsSessionController> cachedSessions;

    private CustomTabsSessionManager factory;

    @Before
    public void setUp() {
        cachedSessions = new HashMap<>();
        factory = new CustomTabsSessionManager(cachedSessions);
    }

    @After
    public void tearDown() {
        factory = null;
    }

    @Test
    public void createSession_withValidPackage_returnsSessionController() {
        try (MockedStatic<CustomTabsIntentHelper> mocked = mockStatic(CustomTabsIntentHelper.class)) {
            final String packageName = "com.example.customtabs";
            mocked.when(() -> getCustomTabsPackage(any(), anyBoolean(), any()))
                    .thenReturn(packageName);

            final CustomTabsSessionOptions options = mock(CustomTabsSessionOptions.class);
            final CustomTabsPackageProvider additionalCustomTabs = mock(CustomTabsPackageProvider.class);
            when(options.getAdditionalCustomTabs(any())).thenReturn(additionalCustomTabs);

            final Context context = mock(Context.class);
            final Pair<String, CustomTabsSessionController> result = factory.createSession(context, options);

            assertThat(result).isNotNull();
            assertThat(result.first).isEqualTo(packageName);
            assertThat(result.second).isNotNull();
            assertThat(cachedSessions.containsKey(packageName)).isTrue();

            mocked.verify(() ->
                    getCustomTabsPackage(any(), eq(true), any())
            );
        }
    }

    @Test
    public void createSession_withNullPackage_returnsNull() {
        try (MockedStatic<CustomTabsIntentHelper> mocked = mockStatic(CustomTabsIntentHelper.class)) {
            mocked.when(() -> getCustomTabsPackage(any(), anyBoolean(), any()))
                    .thenReturn(null);

            final CustomTabsSessionOptions options = mock(CustomTabsSessionOptions.class);
            when(options.getPrefersDefaultBrowser()).thenReturn(true);
            final CustomTabsPackageProvider additionalCustomTabs = mock(CustomTabsPackageProvider.class);
            when(options.getAdditionalCustomTabs(any())).thenReturn(additionalCustomTabs);


            final Context context = mock(Context.class);
            final Pair<String, CustomTabsSessionController> result = factory.createSession(context, options);

            assertThat(result).isNull();
            mocked.verify(() ->
                    getCustomTabsPackage(any(), eq(false), any())
            );
        }
    }

    @Test
    public void getSession_withExistingSession_returnsSession() {
        final String packageName = "com.example.customtabs";
        final CustomTabsSessionController controller = mock(CustomTabsSessionController.class);
        final CustomTabsSession session = mock(CustomTabsSession.class);
        when(controller.getSession()).thenReturn(session);
        cachedSessions.put(packageName, controller);

        final CustomTabsSession result = factory.getSession(packageName);
        assertThat(result).isNotNull();
        assertThat(result).isSameInstanceAs(session);
    }

    @Test
    public void getSession_withNonExistingSession_returnsNull() {
        final CustomTabsSession result = factory.getSession("non.existent.package");
        assertThat(result).isNull();
    }

    @Test
    public void invalidateSession_withExistingSession_removesSession() {
        final String packageName = "com.example.customtabs";
        final CustomTabsSessionController controller = mock(CustomTabsSessionController.class);
        cachedSessions.put(packageName, controller);

        factory.invalidateSession(packageName);

        assertThat(cachedSessions.containsKey(packageName)).isFalse();
        verify(controller).unbindCustomTabsService();
    }

    @Test
    public void invalidateSession_withNonExistentPackage_doesNotRemoveSession() {
        final String packageName = "com.example.customtabs";
        final CustomTabsSessionController controller = mock(CustomTabsSessionController.class);
        cachedSessions.put(packageName, controller);

        factory.invalidateSession("non.existent.package");

        assertThat(cachedSessions.containsKey(packageName)).isTrue();
        verify(controller, never()).unbindCustomTabsService();
    }

    @Test
    public void handleActivityChange_withNullActivity_unbindsAllServices() {
        final String packageName1 = "com.example.customtabs1";
        final CustomTabsSessionController controller1 = mock(CustomTabsSessionController.class);
        cachedSessions.put(packageName1, controller1);

        final String packageName2 = "com.example.customtabs2";
        final CustomTabsSessionController controller2 = mock(CustomTabsSessionController.class);
        cachedSessions.put(packageName2, controller2);

        factory.handleActivityChange(null);

        verify(controller1).unbindCustomTabsService();
        verify(controller2).unbindCustomTabsService();
    }

    @Test
    public void handleActivityChange_withActivity_bindsAllServices() {
        final String packageName1 = "com.example.customtabs1";
        final CustomTabsSessionController controller1 = mock(CustomTabsSessionController.class);
        cachedSessions.put(packageName1, controller1);

        final String packageName2 = "com.example.customtabs2";
        final CustomTabsSessionController controller2 = mock(CustomTabsSessionController.class);
        cachedSessions.put(packageName2, controller2);

        final Context activity = mock(Context.class);
        factory.handleActivityChange(activity);

        verify(controller1).bindCustomTabsService(any(), eq(packageName1));
        verify(controller2).bindCustomTabsService(any(), eq(packageName2));
    }
}