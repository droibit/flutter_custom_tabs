plugins {
  id("com.android.application")
  id("org.jetbrains.kotlin.android")
  id("dev.flutter.flutter-gradle-plugin")
}

android {
  namespace = "com.github.droibit.flutter.plugins.customtabs.example"
  compileSdk = flutter.compileSdkVersion
  ndkVersion = flutter.ndkVersion

  defaultConfig {
    applicationId = "com.github.droibit.flutter.plugins.customtabs.example"
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
}

flutter {
  source = "../.."
}

dependencies {}
