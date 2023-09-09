package com.github.droibit.flutter.plugins.customtabs.example;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("DEBUG", "#onCreate()");
    }
}
