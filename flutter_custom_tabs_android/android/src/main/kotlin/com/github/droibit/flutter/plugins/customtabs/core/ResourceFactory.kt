package com.github.droibit.flutter.plugins.customtabs.core

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.os.Build
import androidx.annotation.AnimRes
import androidx.annotation.AnyRes
import androidx.annotation.Px
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.drawable.DrawableCompat
import androidx.core.graphics.drawable.toBitmap

class ResourceFactory {
    fun getBitmap(context: Context, drawableIdentifier: String?): Bitmap? {
        val drawableResId = resolveIdentifier(context, "drawable", drawableIdentifier)
        if (drawableResId == ResourcesCompat.ID_NULL) {
            return null
        }

        var drawable = ContextCompat.getDrawable(context, drawableResId)
            ?: return null
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            drawable = DrawableCompat.wrap(drawable).mutate()
        }
        return drawable.toBitmap()
    }

    @AnimRes
    fun getAnimationIdentifier(context: Context, identifier: String?): Int {
        return resolveIdentifier(context, "anim", identifier)
    }

    @SuppressLint("DiscouragedApi")
    @AnyRes
    private fun resolveIdentifier(context: Context, defType: String, name: String?): Int {
        val res = context.resources
        return when {
            name == null -> ResourcesCompat.ID_NULL
            fullIdentifierRegex.containsMatchIn(name) -> res.getIdentifier(name, null, null)
            else -> res.getIdentifier(name, defType, context.packageName)
        }
    }

    @Px
    fun convertToPx(context: Context, dp: Double): Int {
        val scale = context.resources.displayMetrics.density
        return (dp * scale + 0.5).toInt()
    }

    private companion object {
        // Note: The full resource qualifier is "package:type/entry".
        // https://developer.android.com/reference/android/content/res/Resources.html#getIdentifier(java.lang.String, java.lang.String, java.lang.String)
        private val fullIdentifierRegex = "^.+:.+/".toRegex()
    }
}
