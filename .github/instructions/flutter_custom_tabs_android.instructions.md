---
applyTo: "flutter_custom_tabs_android/**"
---

# GitHub Copilot Instructions for `flutter_custom_tabs_android`

This file provides context for the **Android implementation package**.

## Path

`flutter_custom_tabs_android/`

## Core Responsibilities

- **Implement the Contract:** Provides the concrete Android implementation for the API defined in `flutter_custom_tabs_platform_interface`.
- **Native Interaction:** Contains the Kotlin code that interfaces with Android's native `androidx.browser.customtabs.CustomTabsIntent` API to provide a customizable browser experience.
- **Registration:** Registers itself as the canonical Android implementation of the platform interface.

## Technical Specifications

- **Minimum Android SDK:** API 19
- **Kotlin Version:** `1.8.0`

## Architecture Overview

The Android implementation is split between Dart and Kotlin, communicating via Pigeon.

### Dart Side

- `lib/flutter_custom_tabs_android.dart`: The main entry point. It registers this package as the Android implementation of `CustomTabsPlatform`.
- `lib/src/custom_tabs_plugin_android.dart`: The main plugin class. It implements `CustomTabsPlatform` and translates calls into Pigeon messages for the native side.
- `lib/src/types/*.dart`: A collection of data classes, with `custom_tabs_options.dart` being the main entry point for developers to configure the Custom Tab's appearance and behavior. These options are serialized into a `Map` for Pigeon.

### Kotlin Side

The native side has a clear separation of concerns:

- `CustomTabsPlugin.kt`: The standard Flutter plugin entry point. Its primary role is to set up the Pigeon channel and wire it to the `CustomTabsLauncher`.
- `CustomTabsLauncher.kt`: The core logic hub and the implementation of the Pigeon API. It receives commands from Dart and orchestrates the launch process. It can delegate to other launchers (e.g., for native app links or external browsers) before finally using a Custom Tab.
- `core/`: This package contains key abstractions:
  - `CustomTabsIntentFactory`: Responsible for converting the `Map` of options from Dart into a fully configured `CustomTabsIntent`.
  - `CustomTabsSessionManager`: Manages the lifecycle of `CustomTabsSession` for features like `warmup()` and `mayLaunchUrl()`.
  - Other launchers like `NativeAppLauncher`, `ExternalBrowserLauncher`, and `PartialCustomTabsLauncher` handle specific launch scenarios.
- `core/options/*.kt`: Contains Kotlin data classes that represent the deserialized options from Dart. `CustomTabsIntentOptions.kt` is the primary container.

## Platform Channel: Pigeon

We use [Pigeon](https://pub.dev/packages/pigeon) for type-safe platform channel communication.

- **Schema:** Defined in `pigeons/messages.dart`. This file is the source of truth for the Dart-Kotlin API.
- **Implementation:** The generated `CustomTabsApi` interface is implemented by `CustomTabsLauncher.kt` on the native side. The Dart client is used in `custom_tabs_plugin_android.dart`.
- **Code Generation:** To regenerate the communication code after modifying the schema, run `dart run pigeon --input pigeons/messages.dart` from the package root.

## Key Contributor Workflow

When adding a new feature (e.g., a new customization option):

1. **Dart Options:** Add the new option to the relevant class in `lib/src/types/`. For example, a new UI option would go into `custom_tabs_options.dart`.
1. **Pigeon Schema:** If the new option needs to be passed to the native side, update the data structures in `pigeons/messages.dart` and regenerate the code.
1. **Native Options:** Add the corresponding field to the native options class (e.g., `core/options/CustomTabsIntentOptions.kt`).
1. **Native Implementation:** Update `CustomTabsIntentFactory.kt` to read the new option and apply it to the `CustomTabsIntent.Builder`.
1. **Connect Dart to Native:** Ensure the top-level Dart plugin class (`custom_tabs_plugin_android.dart`) correctly serializes the new option and passes it through the Pigeon channel.

## Development

This section outlines the common commands used for development in the `flutter_custom_tabs_android` package.

### Setup

Install Dart dependencies:

```bash
flutter pub get
```

### Code Generation (Pigeon)

If you modify the platform channel API in `pigeons/messages.dart`, regenerate the communication code:

```bash
flutter pub run pigeon --input pigeons/messages.dart
```

### Formatting

To ensure consistent code style, use the following command for Dart:

```bash
dart format -o none --set-exit-if-changed $(find ./lib ./test -name "*.dart" -not -name "*.*g.dart")
```

For Kotlin, standard Android Studio formatting applies.

### Static Analysis

Check for potential issues and style violations in your code.

**Dart:**

```bash
flutter analyze .
```

**Android (from the `example/android` directory):**

```bash
./gradlew :flutter_custom_tabs_android:lint
```

### Testing

Run the test suites for both Dart and the native Android code.

**Dart:**

```bash
flutter test
```

**Android (from the `example/android` directory):**

```bash
./gradlew :flutter_custom_tabs_android:testDebugUnitTest
```

### Building and Running the Example App

To build the example app for Android:

```bash
cd example
flutter build apk --release
```

To run the example app:

```bash
cd example
flutter run
```
