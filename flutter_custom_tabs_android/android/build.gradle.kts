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
  implementation("androidx.core:core-ktx:1.9.0")
  implementation("androidx.browser:browser:1.8.0")
  implementation("io.github.droibit:customtabslauncher:3.0.0")

  testImplementation("junit:junit:4.13.2")
  testImplementation("org.robolectric:robolectric:4.11")
  testImplementation("io.mockk:mockk:1.13.3")
  testImplementation("com.google.truth:truth:1.4.4")
  testImplementation("androidx.test.ext:truth:1.6.0")
  testImplementation("androidx.test.ext:junit-ktx:1.2.1")
  testImplementation("com.google.testparameterinjector:test-parameter-injector:1.18")
}
