group = "com.github.droibit.plugins.flutter.customtabs"
version = "1.0-SNAPSHOT"

buildscript {
  repositories {
    google()
    mavenCentral()
  }

  dependencies {
    classpath("com.android.tools.build:gradle:9.0.1")
  }
}

rootProject.allprojects {
  repositories {
    google()
    mavenCentral()
  }
}

plugins {
  id("com.android.library")
}

android {
  namespace = "com.github.droibit.plugins.flutter.customtabs"

  compileSdk = flutter.compileSdkVersion

  defaultConfig {
    minSdk = 19

    vectorDrawables.useSupportLibrary = true
  }

  buildFeatures {
    buildConfig = false
  }

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
  }

  lint {
    checkAllWarnings = true
    warningsAsErrors = true
    disable.addAll(setOf("InvalidPackage", "AndroidGradlePluginVersion", "GradleDependency"))
  }

  testOptions {
    unitTests {
      all {
        it.outputs.upToDateWhen { false }
        it.testLogging {
          events("passed", "skipped", "failed", "standardOut", "standardError")
          showStandardStreams = true
        }
      }
    }
  }
}


kotlin {
  compilerOptions {
    jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    // ref. https://www.reddit.com/r/androiddev/comments/mztyva/a_few_tips_for_testparameterinjector_library/
    freeCompilerArgs.addAll(listOf("-java-parameters"))
  }
}

dependencies {
  implementation("androidx.core:core-ktx:1.10.0")
  implementation("androidx.browser:browser:1.10.0")
  implementation("io.github.droibit:customtabslauncher:4.1.0")

  testImplementation("junit:junit:4.13.2")
  testImplementation("org.robolectric:robolectric:4.16.1")
  testImplementation("io.mockk:mockk:1.14.11")
  testImplementation("com.google.truth:truth:1.4.5")
  testImplementation("androidx.test.ext:truth:1.7.0")
  testImplementation("androidx.test.ext:junit-ktx:1.3.0")
  testImplementation("com.google.testparameterinjector:test-parameter-injector:1.22")
}
