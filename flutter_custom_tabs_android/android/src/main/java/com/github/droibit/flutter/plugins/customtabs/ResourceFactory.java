package com.github.droibit.flutter.plugins.customtabs;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;

import androidx.annotation.AnimRes;
import androidx.annotation.AnyRes;
import androidx.annotation.Dimension;
import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.Px;
import androidx.annotation.RestrictTo;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.drawable.DrawableCompat;

import java.util.regex.Pattern;

@RestrictTo(RestrictTo.Scope.LIBRARY)
class ResourceFactory {
    static final int INVALID_RESOURCE_ID = 0;

    // Note: The full resource qualifier is "package:type/entry".
    // https://developer.android.com/reference/android/content/res/Resources.html#getIdentifier(java.lang.String, java.lang.String, java.lang.String)
    private static final Pattern fullIdentifierPattern = Pattern.compile("^.+:.+/");

    @Nullable
    Bitmap getBitmap(@NonNull Context context, @Nullable String drawableIdentifier) {
        final int drawableResId = resolveIdentifier(context, "drawable", drawableIdentifier);
        if (drawableResId == INVALID_RESOURCE_ID) {
            return null;
        }

        Drawable drawable = ContextCompat.getDrawable(context, drawableResId);
        if (drawable == null) {
            return null;
        }
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            drawable = (DrawableCompat.wrap(drawable)).mutate();
        }
        if (drawable instanceof BitmapDrawable) {
            return ((BitmapDrawable) drawable).getBitmap();
        }
        final Bitmap bitmap = Bitmap.createBitmap(
                drawable.getIntrinsicWidth(),
                drawable.getIntrinsicHeight(),
                Bitmap.Config.ARGB_8888
        );

        final Rect oldBounds = drawable.getBounds();
        final Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);

        drawable.setBounds(oldBounds.left, oldBounds.top, oldBounds.right, oldBounds.bottom);
        return bitmap;
    }

    @AnimRes
    int getAnimationIdentifier(@NonNull Context context, @Nullable String identifier) {
        return resolveIdentifier(context, "anim", identifier);
    }

    @SuppressLint("DiscouragedApi")
    @AnyRes
    private int resolveIdentifier(
            @NonNull Context context,
            @NonNull String defType,
            @Nullable String identifier
    ) {
        if (identifier == null) {
            return INVALID_RESOURCE_ID;
        }
        if (fullIdentifierPattern.matcher(identifier).find()) {
            return context.getResources().getIdentifier(identifier, null, null);
        } else {
            return context.getResources().getIdentifier(identifier, defType, context.getPackageName());
        }
    }

    @Px
    int convertToPx(@NonNull Context context, double dp) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5);
    }
}
