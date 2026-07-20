plugins {
  id("com.android.application")
  id("dev.flutter.flutter-gradle-plugin")
}

android {
  namespace = "com.github.droibit.plugins.flutter.customtabs.android.example"
  compileSdk = flutter.compileSdkVersion
  ndkVersion = flutter.ndkVersion

  defaultConfig {
    applicationId =
      "com.github.droibit.plugins.flutter.customtabs.flutter_custom_tabs_android_example"
    minSdk = flutter.minSdkVersion
    targetSdk = flutter.targetSdkVersion
    versionCode = 1
    versionName = "1.0"
  }

  buildTypes {
    release {
      // Signing with the debug keys for now, so `flutter run --release` works.
      signingConfig = signingConfigs.getByName("debug")
    }
  }

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
  }

  lint {
    disable.add("InvalidPackage")
  }
}

kotlin {
  compilerOptions {
    jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
  }
}


flutter {
  source = "../.."
}
