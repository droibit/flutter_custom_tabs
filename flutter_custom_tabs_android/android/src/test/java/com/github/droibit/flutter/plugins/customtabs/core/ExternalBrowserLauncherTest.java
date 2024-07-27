package com.github.droibit.flutter.plugins.customtabs.core;

import static androidx.test.ext.truth.content.IntentSubject.assertThat;
import static androidx.test.ext.truth.os.BundleSubject.assertThat;
import static com.google.common.truth.Truth.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.same;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static java.util.Collections.singletonMap;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Browser;

import androidx.test.ext.junit.runners.AndroidJUnit4;

import com.github.droibit.flutter.plugins.customtabs.core.options.BrowserConfiguration;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.robolectric.annotation.Config;

import java.util.AbstractMap;

@RunWith(AndroidJUnit4.class)
@Config(manifest = Config.NONE)
public class ExternalBrowserLauncherTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private Context context;

    @InjectMocks
    private ExternalBrowserLauncher launcher;

    @Test
    public void launch_withNullIntent_returnsFalse() {
        final ExternalBrowserLauncher launcher = spy(this.launcher);
        doReturn(null).when(launcher).createIntent(any());

        final Uri uri = Uri.parse("https://example.com");
        final boolean result = launcher.launch(context, uri, null);
        assertThat(result).isFalse();

        verify(context, never()).startActivity(any());
    }

    @Test
    public void launch_withValidIntent_returnsTrue() {
        final ExternalBrowserLauncher launcher = spy(this.launcher);
        final Intent intent = new Intent();
        doReturn(intent).when(launcher).createIntent(any());

        final Uri uri = Uri.parse("https://example.com");
        final boolean result = launcher.launch(context, uri, null);
        assertThat(result).isTrue();

        assertThat(intent).hasData(uri);
        verify(context).startActivity(same(intent));
    }

    @Test
    public void createIntent_nullOptions() {
        final Intent result = launcher.createIntent(null);
        assertThat(result).isNotNull();
        assertThat(result).hasAction(Intent.ACTION_VIEW);
        assertThat(result).extras().isNull();
    }

    @Test
    public void createIntent_emptyBrowserConfiguration() {
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setBrowser(null)
                .build();
        final Intent result = launcher.createIntent(options);
        assertThat(result).isNull();
    }

    @Test
    public void createIntent_prefersCustomTabs() {
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setBrowser(
                        new BrowserConfiguration.Builder()
                                .setPrefersExternalBrowser(false)
                                .build()
                )
                .build();
        final Intent result = launcher.createIntent(options);
        assertThat(result).isNull();
    }

    @Test
    public void createIntent_noHeaders() {
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setBrowser(
                        new BrowserConfiguration.Builder()
                                .setPrefersExternalBrowser(true)
                                .build()
                )
                .build();
        final Intent result = launcher.createIntent(options);
        assertThat(result).isNotNull();
        assertThat(result).hasAction(Intent.ACTION_VIEW);
        assertThat(result).extras().isNull();
    }

    @Test
    public void createIntent_addedHeaders() {
        final AbstractMap.SimpleEntry<String, String> expHeader = new AbstractMap.SimpleEntry<>("key", "value");
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setBrowser(
                        new BrowserConfiguration.Builder()
                                .setPrefersExternalBrowser(true)
                                .setHeaders(singletonMap(expHeader.getKey(), expHeader.getValue()))
                                .build()
                )
                .build();
        final Intent result = launcher.createIntent(options);
        assertThat(result).isNotNull();
        assertThat(result).hasAction(Intent.ACTION_VIEW);
        assertThat(result).extras().hasSize(1);

        //noinspection DataFlowIssue
        final Bundle actualHeaders = result.getBundleExtra(Browser.EXTRA_HEADERS);
        assertThat(actualHeaders).isNotNull();
        assertThat(actualHeaders).hasSize(1);
        assertThat(actualHeaders).string(expHeader.getKey()).isEqualTo(expHeader.getValue());
    }
}