package com.github.droibit.flutter.plugins.customtabs;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * ref. <a href="https://developer.chrome.com/docs/android/custom-tabs/howto-custom-tab-native-apps/">Let native applications handle the content</a>
 */
@RestrictTo(RestrictTo.Scope.LIBRARY)
class NativeAppLauncher {
    static boolean launch(@NonNull Context context, @NonNull Uri uri) {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.R ?
                launchNativeApi30(context, uri) :
                launchNativeBeforeApi30(context, uri);
    }

    @RequiresApi(api = Build.VERSION_CODES.R)
    private static boolean launchNativeApi30(@NonNull Context context, @NonNull Uri uri) {
        final Intent nativeAppIntent = new Intent(Intent.ACTION_VIEW, uri)
                .addCategory(Intent.CATEGORY_BROWSABLE)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_REQUIRE_NON_BROWSER);
        try {
            context.startActivity(nativeAppIntent);
            return true;
        } catch (ActivityNotFoundException ignored) {
            return false;
        }
    }

    private static boolean launchNativeBeforeApi30(@NonNull Context context, @NonNull Uri uri) {
        final PackageManager pm = context.getPackageManager();

        // Get all Apps that resolve a generic url
        final Intent browserActivityIntent = new Intent()
                .setAction(Intent.ACTION_VIEW)
                .addCategory(Intent.CATEGORY_BROWSABLE)
                .setData(Uri.fromParts(uri.getScheme(), "", null));
        final Set<String> genericResolvedList =
                extractPackageNames(queryIntentActivities(pm, browserActivityIntent));

        // Get all apps that resolve the specific Url
        final Intent specializedActivityIntent = new Intent(Intent.ACTION_VIEW, uri)
                .addCategory(Intent.CATEGORY_BROWSABLE);
        final Set<String> resolvedSpecializedList =
                extractPackageNames(queryIntentActivities(pm, specializedActivityIntent));

        // Keep only the Urls that resolve the specific, but not the generic urls.
        resolvedSpecializedList.removeAll(genericResolvedList);
        // If the list is empty, no native app handlers were found.
        if (resolvedSpecializedList.isEmpty()) {
            return false;
        }

        // We found native handlers. Launch the Intent.
        specializedActivityIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(specializedActivityIntent);
        return true;
    }

    @SuppressWarnings("deprecation")
    private static @NonNull List<ResolveInfo> queryIntentActivities(
            @NonNull PackageManager pm,
            @NonNull Intent intent
    ) {
        final int flags = Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
                ? PackageManager.MATCH_ALL : PackageManager.MATCH_DEFAULT_ONLY;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return pm.queryIntentActivities(
                    intent,
                    PackageManager.ResolveInfoFlags.of(flags)
            );
        } else {
            return pm.queryIntentActivities(intent, flags);
        }
    }

    private static @NonNull Set<String> extractPackageNames(@NonNull List<ResolveInfo> resolveInfo) {
        final Set<String> packageNames = new HashSet<>(resolveInfo.size());
        for (ResolveInfo info : resolveInfo) {
            packageNames.add(info.activityInfo.packageName);
        }
        return packageNames;
    }

}
