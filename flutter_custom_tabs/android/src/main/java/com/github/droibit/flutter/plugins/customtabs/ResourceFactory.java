package com.github.droibit.flutter.plugins.customtabs;

import android.annotation.SuppressLint;
import android.content.Context;

import androidx.annotation.AnimRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;

import java.util.regex.Pattern;

@RestrictTo(RestrictTo.Scope.LIBRARY)
class ResourceFactory {
    static final int INVALID_RESOURCE_ID = 0;

    // Note: The full resource qualifier is "package:type/entry".
    // https://developer.android.com/reference/android/content/res/Resources.html#getIdentifier(java.lang.String, java.lang.String, java.lang.String)
    private static final Pattern fullIdentifierPattern = Pattern.compile("^.+:.+/");

    @SuppressLint("DiscouragedApi")
    @AnimRes
    static int resolveAnimationIdentifier(
            @NonNull Context context,
            @Nullable String identifier
    ) {
        if (identifier == null) {
            return INVALID_RESOURCE_ID;
        }
        if (fullIdentifierPattern.matcher(identifier).find()) {
            return context.getResources().getIdentifier(identifier, null, null);
        } else {
            return context.getResources().getIdentifier(identifier, "anim", context.getPackageName());
        }
    }
}
