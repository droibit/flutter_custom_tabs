---
applyTo: "flutter_custom_tabs/**"
---

# GitHub Copilot Instructions for `flutter_custom_tabs`

This file provides context for the **app-facing package**.

## Path

`flutter_custom_tabs/`

## Core Responsibilities

- **Provide Public APIs:** Offers two distinct, developer-friendly APIs for launching URLs in a customized in-app browser.
- **Delegate to Platform Interface:** Acts as the primary entry point that delegates all functionality to the `flutter_custom_tabs_platform_interface` package. It does not contain any platform-specific implementation itself.

## Architecture Overview

This package serves as the app-facing layer, providing developers with two different ways to use the plugin, depending on their needs for simplicity versus control.

### 1. Full API (`flutter_custom_tabs.dart`)

This is the complete, feature-rich API that provides maximum control over the in-app browser's appearance and behavior.

- **Entry Point:** `flutter_custom_tabs.dart`
- **Key Function:** `launch()`
- **Options:** It directly accepts the platform-specific option classes (`CustomTabsOptions` for Android and `SafariViewControllerOptions` for iOS) defined in the `flutter_custom_tabs_platform_interface` package.
- **Use Case:** Ideal for developers who need to fine-tune every detail of the browser experience on each platform.

### 2. Lite API (`flutter_custom_tabs_lite.dart`)

This is a simplified, cross-platform API designed for ease of use. It abstracts away platform-specific details.

- **Entry Point:** `flutter_custom_tabs_lite.dart`
- **Key Function:** `launchUrl()` (defined in `lib/src/lite/launcher_lite.dart`)
- **Options:** It uses a single, simplified `LaunchOptions` class (defined in `lib/src/lite/launch_options.dart`). This `LaunchOptions` object is internally converted into the appropriate platform-specific options (`CustomTabsOptions` or `SafariViewControllerOptions`) before being passed to the platform interface.
- **Use Case:** Perfect for developers who want a consistent and easy way to launch a themed in-app browser without worrying about the underlying platform differences.

## Key Contributor Workflow

When adding a new feature, the typical workflow is as follows:

1. **Platform Interface:** Define the new feature in `flutter_custom_tabs_platform_interface`.
1. **Platform Implementations:** Implement the feature in the Android (`flutter_custom_tabs_android`) and/or iOS (`flutter_custom_tabs_ios`) packages.
1. **Full API:** Expose the new feature through the `launch()` function and the platform-specific options classes if necessary.
1. **Lite API (if applicable):**
    - If the new feature is simple and cross-platform, add a corresponding property to the `LaunchOptions` class in `lib/src/lite/launch_options.dart`.
    - Update the internal conversion logic in `lib/src/lite/type_conversion.dart` to map the new `LaunchOptions` property to the corresponding platform-specific option.

## Development

This section outlines the common commands used for development in the `flutter_custom_tabs` package.

### Setup

Install Dart dependencies:

```bash
flutter pub get
```

### Formatting

To ensure consistent code style, use the following command:

```bash
dart format --set-exit-if-changed .
```

### Static Analysis

Check for potential issues and style violations in your code:

```bash
flutter analyze .
```

### Testing

Run the test suite for the package:

```bash
flutter test
```

### Building and Running the Example App

The example app demonstrates the usage of both the full and lite APIs.

To build the example app:

**Android:**

```bash
cd example
flutter build apk --release
```

**iOS:**

```bash
cd example
flutter build ios --no-codesign
```

To run the example app:

```bash
cd example
flutter run
```
